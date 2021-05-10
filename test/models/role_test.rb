require "test_helper"

class RoleTest < ActiveSupport::TestCase

  test 'supplier name should be "supplier"' do
    role = roles(:supplier)

    assert_equal 'supplier', role[:name]
  end

  test 'admin name should be "admin"' do
    role = roles(:admin)

    assert_equal 'admin', role[:name]
  end

  test 'should add role "supplier" to cain' do
    user = users(:cain)
    user.add_role :supplier

    assert user.has_role? :supplier
  end

  test 'should add role "admin" to abel' do
    user = users(:abel)
    user.add_role :admin

    assert user.has_role? :admin
  end

  test 'cain and abel should have role "organizer"' do
    cain = users(:cain)
    cain.add_role :organizer
    abel = users(:abel)
    abel.add_role :organizer

    assert_equal cain.has_role?(:organizer), abel.has_role?(:organizer)
  end

  test 'should delete role "supplier" from cain' do
    user = users(:cain)
    user.add_role :supplier
    assert user.has_role? :supplier
    user.remove_role :supplier

    assert_not user.has_role? :supplier
  end

  test 'abel should have role "organizer" and "admin"' do
    user = users(:abel)
    user.add_role :organizer
    user.add_role :admin

    assert_equal 2, user.roles.size
    assert user.has_role? :organizer
    assert user.has_role? :admin
  end

end
