class HomeController < ApplicationController
  layout "info", :except => [:popular, :trending]
  def popular
    @branches = Branch.popular
  end

  def trending
    @branches = Branch.trending
  end

  def faq

  end
end
