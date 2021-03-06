require "test_helper"

class CategoryTest < ActiveSupport::TestCase

  test 'Should not save category whitout a name' do
    category = Category.new
    assert_not category.save
  end

  test 'Name should have at least 5 characters' do
    category = Category.new
    category[:name] = 'GGEZ'
    assert_not category.save
  end

  test 'Name should be unique' do
    category = Category.new
    category[:name] = categories(:raquette_bad)[:name]
    assert_not category.save
  end

  test 'Should update raquettes\'s name to "Bubble"' do
    category = categories(:raquettes)
    assert category.update({ name: 'Bubble' })
    assert_equal 'Bubble', category[:name]
  end

  test 'Should update balle_ten\'s parent (balles)\'name to "Hello"' do
    category = categories(:balle_ten)
    assert category.parent.update({ name: 'Hello' })
    assert_equal 'Hello', category.parent[:name]
  end

  test 'Should delete Balles' do
    category = categories(:balles)
    assert category.destroy
  end

  test 'Balle_ten\'s parent\'name should be "Balles pour jouer"' do
    category = categories(:balle_ten)
    assert_equal 'Balles pour jouer', category.parent[:name]
  end

  test 'Raquette\'s childen\'names shoulde be "Raquette de badminton" and "Raquette de tennis"' do
    category = categories(:raquettes)
    assert_equal 'Raquette de badminton', category.children[0][:name]
    assert_equal 'Raquette de tennis', category.children[1][:name]
  end

end
