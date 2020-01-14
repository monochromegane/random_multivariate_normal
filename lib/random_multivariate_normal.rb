require 'matrix'
require "random_multivariate_normal/version"

class RandomMultivariateNormal
  def initialize(seed = Random.new_seed)
    @rnd = Random.new(seed)
  end

  def rand(mean, cov)
    rand_multivariate_norm(@rnd, mean, cov)
  end

  private

  def rand_multivariate_norm(rnd, mu, cov)
    z = Vector[*mu.size.times.map{rand_norm(rnd)}]
    l = cholesky_foctor(cov)
    l*z+mu
  end

  def rand_norm(rnd)
    box_muller(rnd.rand, rnd.rand)[0]
  end

  def box_muller(x, y)
    z1 = Math.sqrt(-2 * Math.log(x)) * Math.cos(2 * Math::PI * y)
    z2 = Math.sqrt(-2 * Math.log(x)) * Math.sin(2 * Math::PI * y)
    [z1, z2]
  end

  def cholesky_foctor(mat)
    raise ArgumentError.new('Not symmetric matrix') unless mat.symmetric?
    raise ArgumentError.new('Not positive definite matrix') unless mat.eigen.d.each(:diagonal).all?{|d| d > 0.0}

    l = Matrix.zero(mat.row_size)
    mat.each_with_index do |e, row, col|
      lij = if row == col
              Math.sqrt(mat[col, col] - col.times.inject(0){|sum, j| sum + (l[col, j] ** 2)})
            elsif row > col
              (1.0/l[col, col]) * (mat[row, col] - col.times.inject(0){|sum, j| sum + l[row, j] * l[col, j]})
            else
              0.0
            end
      l[row, col] = lij
    end
    l
  end
end
