# ================================================================
# 2015/04/19 Thomas
# Purpose: just to run any test
# ================================================================

require_relative 'spec_helper'
require_relative FileNames::LIB_BASE_PAGE




describe 'Test login page' do
	searchBar		= { name: 'q' }		#For google.com, search bar
	submitButton	= { name: 'btnG' }		#For google.com, submit button
	checkbox = { name: 'sports' }		#For http://www.tizag.com/htmlT/htmlcheckboxes.php

	before(:each) do
		@basePage				= BasePage.new(@driver)
	end
	after(:each) do
	end


	it 'positive-username' do
		print "TEST\n"
		@basePage.visit("http://www.google.com")
		#@basePage.type(searchBar, "ruby")
		#@basePage.click(submitButton)

		#@basePage.visit("http://www.tizag.com/htmlT/htmlcheckboxes.php")
		#@basePage.click(checkbox)
		#@basePage.click(checkbox, :check => false)

		print @basePage.compare_URL("  www.cnn.com\\  ", "www.CNN.com ")
	end
end