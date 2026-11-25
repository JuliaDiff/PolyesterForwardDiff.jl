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
PolyesterForwardDiff.threaded_jacobian!(g, dx, x, ForwardDiff.Chunk(8),Val{true}());
@test dx ≈ dxref

PolyesterForwardDiff.threaded_jacobian!(g!, y, dx, x, ForwardDiff.Chunk(8));
ForwardDiff.jacobian!(dxref, g!, yref, x, ForwardDiff.JacobianConfig(g!, yref, x, ForwardDiff.Chunk(8), nothing));
@test dx ≈ dxref
@test y ≈ yref
PolyesterForwardDiff.threaded_jacobian!(g!, y, dx, x, ForwardDiff.Chunk(8),Val{true}());
@test dx ≈ dxref
@test y ≈ yref


X = randn(10,80);
dXref = similar(X);
dX = similar(X);
ForwardDiff.gradient!(dXref, f, X, ForwardDiff.GradientConfig(f, X, ForwardDiff.Chunk(8), nothing));
PolyesterForwardDiff.threaded_gradient!(f, dX, X, ForwardDiff.Chunk(8));

@test dX ≈ dXref

@testset "closures capturing data" begin
    make_loss(obs) = p -> sum(abs2, p .- obs) + sum(sum ∘ sincos, p)
    xc = randn(803)
    fc = make_loss(randn(803))
    @test !Base.issingletontype(typeof(fc))
    dxc = similar(xc)
    ref = ForwardDiff.gradient(fc, xc)
    for check in (Val{false}(), Val{true}())
        for _ in 1:50
            dxc .= NaN
            val = PolyesterForwardDiff.threaded_gradient!(fc, dxc, xc, ForwardDiff.Chunk(8), check)
            @test dxc ≈ ref
            @test val ≈ fc(xc)
        end
    end

    B = randn(100, 803)
    hc = let B = B; x -> B * x; end
    hc! = let B = B; (y, x) -> (y .= B * x); end
    Jref = ForwardDiff.jacobian(hc, xc)
    J = similar(Jref); yc = similar(xc, 100)
    for check in (Val{false}(), Val{true}())
        J .= NaN
        PolyesterForwardDiff.threaded_jacobian!(hc, J, xc, ForwardDiff.Chunk(8), check)
        @test J ≈ Jref
        J .= NaN; yc .= NaN
        PolyesterForwardDiff.threaded_jacobian!(hc!, yc, J, xc, ForwardDiff.Chunk(8), check)
        @test J ≈ Jref
        @test yc ≈ B * xc
    end
end
