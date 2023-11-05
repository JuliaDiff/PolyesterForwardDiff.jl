println("Starting tests with $(Threads.nthreads()) threads out of `Sys.CPU_THREADS = $(Sys.CPU_THREADS)`...")
using Polyester, PolyesterForwardDiff, Test, ForwardDiff

x = randn(800);
dxref = similar(x);
dx = similar(x);
f(x) = -sum(sum ∘ sincos, x)
println("Running threaded ForwardDiff test...")
PolyesterForwardDiff.threaded_gradient!(f, dx, x, ForwardDiff.Chunk(8));
ForwardDiff.gradient!(dxref, f, x, ForwardDiff.GradientConfig(f, x, ForwardDiff.Chunk(8), nothing));
@test dx == dxref

dx .= NaN;
batch((length(x), max(1,Threads.nthreads()>>1), 2), dx, x) do (dx,x), start, stop
    PolyesterForwardDiff.threaded_gradient!(f, view(dx, start%Int:stop%Int), view(x, start%Int:stop%Int), ForwardDiff.Chunk(8))
end;
@test dx ≈ dxref

dxref = similar(x, 100, 800);
dx = similar(dxref);
yref = similar(x, 100);
y = similar(x, 100);
A = randn(100, 800);
g!(y, x) = (y .= A*x)
g(x) = A*x

PolyesterForwardDiff.threaded_jacobian!(g, dx, x, ForwardDiff.Chunk(8));
ForwardDiff.jacobian!(dxref, g, x, ForwardDiff.JacobianConfig(g, x, ForwardDiff.Chunk(8), nothing));
@test dx ≈ dxref

PolyesterForwardDiff.threaded_jacobian!(g!, y, dx, x, ForwardDiff.Chunk(8));
ForwardDiff.jacobian!(dxref, g!, yref, x, ForwardDiff.JacobianConfig(g!, yref, x, ForwardDiff.Chunk(8), nothing));
@test dx ≈ dxref
@test y ≈ yref
