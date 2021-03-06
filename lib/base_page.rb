# ================================================================
# Created:	2015/03/13
# Author:	Thomas Nguyen - thomas_ejob@hotmail.com
# Purpose:	set of Selenium methods that should universally work on all websites
# Source:	http://anahorny.blogspot.in/2011/08/selenium-webdriver-ruby-tutorial.html
# ================================================================

require_relative FileNames::LIB_MY_FILE
require "open-uri"

class BasePage
	def initialize(driver)
		@driver = driver		#= super(driver)
		#@driver.manage.timeouts.implicit_wait	= 60
		#@driver.manage.timeouts.script_timeout	= 60
		#@driver.manage.timeouts.page_load		= 60
	end

	# ----------------------------------------------------------------
	#Windows
	# ----------------------------------------------------------------
	def get_title
		return @driver.title
	end

	def visit(url_path)
		begin
			@driver.get fix_URL(url_path)
			return true
		rescue
			return false
		end
	end
	def fix_URL(url)
		url = url.strip
		if url =~ %r{\Awww\.}i
			url = "http://"+ url
		end
		url = url.sub(/\\$/, "")
		return url
	end
	def compare_URL(url1, url2)
		url1 = fix_URL(url1).downcase
		url2 = fix_URL(url2).downcase
		if (url1==url2)
			return true
		else
			return false
		end
	end
	def get_current_url()
		return @driver.current_url
	end
	def navigate_forward()
		@driver.navigate().forward();
	end
	def navigate_refresh()
		@driver.navigate().refresh();
	end
	def navigate_back()
		@driver.navigate().back();
	end
	def window_maximize()
		@driver.manage().window().maximize()
	end
	def window_resize(parameters = {})
		height	= parameters[:height] || Constants::WINDOW_HEIGHT_DEFAULT
		width	= parameters[:width] || Constants::WINDOW_WIDTH_DEFAULT
		@driver.manage.window.resize_to(height, width)
	end

	# ----------------------------------------------------------------
	#Locators
	# ----------------------------------------------------------------
	def find(locator)
		return @driver.find_element(locator)
	end
	def finds(locator)
		return @driver.find_elements(locator)
	end
	def count_elements(locator)
		return @driver.find_elements(locator).size()
	end

	# ----------------------------------------------------------------
	#Verify
	# ----------------------------------------------------------------
	def is_displayed?(locator)
		begin
			return find(locator).displayed?
		rescue Selenium::WebDriver::Error::NoSuchElementError
			return false
		end
	end
	def text_displayed?(locator, elementText)
		begin
			return find(locator).text.include?(elementText)
		rescue
			return false
		end
	end
	def text_present(locator)
		begin
			return find(locator).text
		rescue
			return ""
		end
	end

	# ----------------------------------------------------------------
	#Forms: input, buttons & select
	# ----------------------------------------------------------------
	def typeNew(locator, text)
		clear(locator)
		find(locator).send_keys(text)
	end
	def type(locator, text)
		find(locator).send_keys(text)
	end
	def clear(locator)
		find(locator).clear()
	end
	def select(locator, optionText)
		dropdown = find(locator)

		#This also works:
		#options = dropdown.find_elements(:tag_name => "option");
		#options.each do |g|
		#	if g.text == optionText
		#		g.click
		#		break
		#	end
		#end

		select_list = Selenium::WebDriver::Support::Select.new(dropdown)
		select_list.select_by(:text, optionText)
	end
	def click(locator, parameters = {})
		wait_for(locator)
		checkBox		= parameters[:check] || "null"

		if ((checkBox=="true") || (checkBox=="1"))
			locator.clear
			find(locator).click
		elsif ((checkBox=="false") || (checkBox=="0"))
			locator.clear
		else
			find(locator).click
		end
	end
	def submit(locator)
		wait_for(locator)
		find(locator).submit
	end

	# ----------------------------------------------------------------
	#Pictures
	# ----------------------------------------------------------------
	def take_screenshot(file_name = FileNames::SCREENSHOT_FOLDER + FileNames::SCREENSHOT_FILENAME)
		directory_name	= FileNames::SCREENSHOT_FOLDER
		file_name		= MyFile.new(file_name).gen_unique_file_name

		Dir.mkdir(directory_name) unless File.exists?(directory_name)
		@driver.save_screenshot(directory_name + file_name)
	end
	def downloadPict(locator, file_name = FileNames::SCREENSHOT_FOLDER + FileNames::SCREENSHOT_FILENAME)
		picture	= find( locator )
		url		= picture.attribute("src")
		open(file_name, 'wb') do |file|
		  file << open(url).read
		end
	end

	# ----------------------------------------------------------------
	#Wait, Selenium is too fast ^_^
	# ----------------------------------------------------------------
	def wait_for(seconds = 15)
		Selenium::WebDriver::Wait.new(timeout: seconds).until { yield }
	end
	def wait_for(locator, seconds = 15)
		wait = Selenium::WebDriver::Wait.new(:timeout => 10)
		begin
			wait.until { find(locator) }
			return true
		rescue
			return false
		end
	end

	# ----------------------------------------------------------------
	#Other methods
	# ----------------------------------------------------------------
end