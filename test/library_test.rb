require 'Minitest/autorun'
require 'Minitest/pride'
require './lib/book'
require './lib/author'
require './lib/library'

class LibraryTest < Minitest::Test
    def setup
        @dpl = Library.new("Denver Public Library")
        @charlotte_bronte = Author.new({
            first_name: "Charlotte",
            last_name: "Bronte"}
        )
        @harper_lee = Author.new({
            first_name: "Harper", 
            last_name: "Lee"
            }
        )
    end

    def test_it_exists_and_has_attributes
        assert_instance_of Library, @dpl
        assert_equal "Denver Public Library", @dpl.name
        assert_equal [], @dpl.books
        assert_equal [], @dpl.authors
    end

    def test_it_can_add_authors
        jane_eyre = @charlotte_bronte.write("Jane Eyre", "October 16, 1847")
        professor = @charlotte_bronte.write("The Professor", "1857")
        villette = @charlotte_bronte.write("Villette", "1853")
        mockingbird = @harper_lee.write("To Kill a Mockingbird", "July 11, 1960")

        @dpl.add_author(@charlotte_bronte)
        @dpl.add_author(@harper_lee)

        expected_1 = [@charlotte_bronte, @harper_lee]
        expected_2 = [jane_eyre, professor, villette, mockingbird]

        assert_equal expected_1, @dpl.authors
        assert_equal expected_2, @dpl.books
    end

    def test_it_can_return_publication_time_frame_by_author
        jane_eyre = @charlotte_bronte.write("Jane Eyre", "October 16, 1847")
        professor = @charlotte_bronte.write("The Professor", "1857")
        villette = @charlotte_bronte.write("Villette", "1853")
        mockingbird = @harper_lee.write("To Kill a Mockingbird", "July 11, 1960")
        
        @dpl.add_author(@charlotte_bronte)
        @dpl.add_author(@harper_lee)

        expected_1 = {:start=>"1847", :end=>"1857"}
        expected_2 = {:start=>"1960", :end=>"1960"}

        assert_equal expected_1, @dpl.publication_time_frame_for(@charlotte_bronte)        
        assert_equal expected_2, @dpl.publication_time_frame_for(@harper_lee)
    end

    def test_it_can_checkout
        jane_eyre = @charlotte_bronte.write("Jane Eyre", "October 16, 1847")
        villette = @charlotte_bronte.write("Villette", "1853")
        mockingbird = @harper_lee.write("To Kill a Mockingbird", "July 11, 1960")

        refute @dpl.checkout(mockingbird)
        refute @dpl.checkout(jane_eyre)
        
        @dpl.add_author(@charlotte_bronte)
        @dpl.add_author(@harper_lee)    

        assert @dpl.checkout(jane_eyre)
    end

    def test_it_can_list_checked_out_books
        jane_eyre = @charlotte_bronte.write("Jane Eyre", "October 16, 1847")
        villette = @charlotte_bronte.write("Villette", "1853")
        mockingbird = @harper_lee.write("To Kill a Mockingbird", "July 11, 1960")
        
        @dpl.add_author(@charlotte_bronte)
        @dpl.add_author(@harper_lee)  
        @dpl.checkout(jane_eyre)

        assert_equal [jane_eyre], @dpl.checked_out_books
        refute @dpl.checkout(jane_eyre)
    end

    def test_it_can_return_books
        jane_eyre = @charlotte_bronte.write("Jane Eyre", "October 16, 1847")
        villette = @charlotte_bronte.write("Villette", "1853")
        mockingbird = @harper_lee.write("To Kill a Mockingbird", "July 11, 1960")
        
        @dpl.add_author(@charlotte_bronte)
        @dpl.add_author(@harper_lee)  
        @dpl.checkout(jane_eyre)
        @dpl.return(jane_eyre)

        assert_equal [], @dpl.checked_out_books
        
        @dpl.checkout(jane_eyre)
        @dpl.checkout(villette)
        
        assert_equal [jane_eyre, villette], @dpl.checked_out_books
    end

    def test_it_can_provide_most_popular_book
        jane_eyre = @charlotte_bronte.write("Jane Eyre", "October 16, 1847")
        villette = @charlotte_bronte.write("Villette", "1853")
        mockingbird = @harper_lee.write("To Kill a Mockingbird", "July 11, 1960")
        
        @dpl.add_author(@charlotte_bronte)
        @dpl.add_author(@harper_lee)  
        @dpl.checkout(jane_eyre)
        @dpl.return(jane_eyre)        
        @dpl.checkout(jane_eyre)
        @dpl.checkout(villette)        
        @dpl.checkout(mockingbird)
        @dpl.return(mockingbird)
        @dpl.checkout(mockingbird)
        @dpl.return(mockingbird)
        @dpl.checkout(mockingbird)


        assert_equal mockingbird, @dpl.most_popular_book
    end

end