# -*- encoding : utf-8 -*-
require 'test_helper'

class SidebarBlockCellTest < ActionController::TestCase
  include Cells::AssertionsHelper
  
    test "news" do
    html = render_cell(:sidebar_block, :news)
    #assert_selekt html, "div"
  end
  
    test "comments" do
    html = render_cell(:sidebar_block, :comments)
    #assert_selekt html, "div"
  end
  
    test "shop" do
    html = render_cell(:sidebar_block, :shop)
    #assert_selekt html, "div"
  end
  
  
end
