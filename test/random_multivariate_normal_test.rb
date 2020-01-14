require "test_helper"

class RandomMultivariateNormalTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::RandomMultivariateNormal::VERSION
  end

  def test_that_it_returns_number_same_as_dim
    dim = 3
    mean = Vector.zero(dim)
    cov  = Matrix.I(dim)
    assert_equal dim, ::RandomMultivariateNormal.new.rand(mean, cov).size
  end

  def test_that_it_raises_argument_error_if_cov_is_not_symmetric
    dim = 3
    mean = Vector.zero(dim)
    cov  = Matrix.I(dim)
    cov[0,1] = 1

    assert_raises(ArgumentError) do
      ::RandomMultivariateNormal.new.rand(mean, cov)
    end
  end

  def test_that_it_raises_argument_error_if_cov_is_not_positive_definite
    dim = 3
    mean = Vector.zero(dim)
    cov = Matrix[*[[25.0, 15.0, -5.0], [15.0, 18.0, 0.0], [-5.0, 0.0, -11.0]]]

    assert_raises(ArgumentError) do
      ::RandomMultivariateNormal.new.rand(mean, cov)
    end
  end

  def test_that_it_can_get_correct_cholesky_foctor
    mat    = Matrix[*[[25.0, 15.0, -5.0], [15.0, 18.0, 0.0], [-5.0, 0.0, 11.0]]]
    expect = Matrix[*[[5.0, 0.0, 0.0],    [3.0, 3.0, 0.0],   [-1.0, 1.0, 3.0]]]

    l = ::RandomMultivariateNormal.new.send(:cholesky_foctor, mat)
    assert l.each_with_index.all?{|e, row, col| e == expect[row, col]}
  end
end
