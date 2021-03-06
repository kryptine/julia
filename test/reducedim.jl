
# Supporting routines

@test Base.rcompress_dims((3, 4), 1) == (true,  [3, 4])
@test Base.rcompress_dims((3, 4), 2) == (false, [3, 4])
@test Base.rcompress_dims((3, 4), 3) == (false, [12])
@test Base.rcompress_dims((3, 4), (1, 2)) == (true, [12])

@test Base.rcompress_dims((3, 4, 5), 1) == (true,  [3, 20])
@test Base.rcompress_dims((3, 4, 5), 2) == (false, [3, 4, 5])
@test Base.rcompress_dims((3, 4, 5), 3) == (false, [12, 5])
@test Base.rcompress_dims((3, 4, 5), (1, 2)) == (true,  [12, 5])
@test Base.rcompress_dims((3, 4, 5), (1, 3)) == (true,  [3, 4, 5])
@test Base.rcompress_dims((3, 4, 5), (2, 3)) == (false, [3, 20])
@test Base.rcompress_dims((3, 4, 5), (1, 2, 3)) == (true, [60])

@test Base.rcompress_dims((3, 4, 5, 2), 1) == (true,  [3, 40])
@test Base.rcompress_dims((3, 4, 5, 2), 2) == (false, [3, 4, 10])
@test Base.rcompress_dims((3, 4, 5, 2), 3) == (false, [12, 5, 2])
@test Base.rcompress_dims((3, 4, 5, 2), 4) == (false, [60, 2])
@test Base.rcompress_dims((3, 4, 5, 2), (1, 2)) == (true,  [12, 10])
@test Base.rcompress_dims((3, 4, 5, 2), (1, 3)) == (true,  [3, 4, 5, 2])
@test Base.rcompress_dims((3, 4, 5, 2), (1, 4)) == (true,  [3, 20, 2])
@test Base.rcompress_dims((3, 4, 5, 2), (2, 3)) == (false, [3, 20, 2])
@test Base.rcompress_dims((3, 4, 5, 2), (2, 4)) == (false, [3, 4, 5, 2])
@test Base.rcompress_dims((3, 4, 5, 2), (3, 4)) == (false, [12, 10])
@test Base.rcompress_dims((3, 4, 5, 2), (1, 2, 3)) == (true,  [60, 2])
@test Base.rcompress_dims((3, 4, 5, 2), (1, 2, 4)) == (true,  [12, 5, 2])
@test Base.rcompress_dims((3, 4, 5, 2), (1, 3, 4)) == (true,  [3, 4, 10])
@test Base.rcompress_dims((3, 4, 5, 2), (2, 3, 4)) == (false, [3, 40])
@test Base.rcompress_dims((3, 4, 5, 2), (1, 2, 3, 4)) == (true, [120])

# main tests

safe_sum{T}(A::Array{T}, region) = reducedim(+, A, region, zero(T))
safe_prod{T}(A::Array{T}, region) = reducedim(*, A, region, one(T))
safe_maximum{T}(A::Array{T}, region) = reducedim(Base.scalarmax, A, region, typemin(T))
safe_minimum{T}(A::Array{T}, region) = reducedim(Base.scalarmin, A, region, typemax(T))

Areduc = rand(3, 4, 5, 6)
for region in {
	1, 2, 3, 4, 5, (1, 2), (1, 3), (1, 4), (2, 3), (2, 4), (3, 4), 
	(1, 2, 3), (1, 3, 4), (2, 3, 4), (1, 2, 3, 4)}

	@test_approx_eq sum(Areduc, region) safe_sum(Areduc, region)
	@test_approx_eq prod(Areduc, region) safe_prod(Areduc, region)
	@test_approx_eq maximum(Areduc, region) safe_maximum(Areduc, region)
	@test_approx_eq minimum(Areduc, region) safe_minimum(Areduc, region)
end

