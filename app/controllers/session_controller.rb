class SessionController < ApplicationController
	
	attr_accessor :parameters			# Variable params from views
	attr_accessor :user_id				# Current user id ( -1 if no user is logged in)
	attr_accessor :new_user				# Boolean for stating if the user is new or not
	
	def initialize
		self.parameters = {}
		self.user_id = -1
		self.new_user = false
	end

	def set_credentials(params)
		self.parameters["email"] = params[:email][0]
		self.parameters["password"] = params[:password]
	end
	
	def set_register_data(params)
		self.parameters["first_name"] = params[:first_name]
		self.parameters["last_name"] = params[:last_name]		
		self.parameters["email"] = params[:email][0]
		self.parameters["re_email"] = params[:re_email][0]
		self.parameters["password"] = params[:password]
		self.parameters["re_password"] = params[:re_password]
		self.parameters["gender"] = params[:gender]
		self.parameters["birthdate"] = params[:birthdate]
	end

	def set_change_pass(params)
		self.user_id = self.decrypt_id(params[:user_id])
		self.parameters["old_password"] = params[:old_password]
		self.parameters["password"] = params[:password]
		self.parameters["re_password"] = params[:re_password]
	end
	
	def set_profile(params)
		self.user_id = self.decrypt_id(params[:user_id])
		self.parameters["color1"] =  params[:color1]
		self.parameters["color2"] =  params[:color2]
		self.parameters["color3"] =  params[:color3]
		self.parameters["model1"] =  params[:model1]
		self.parameters["model2"] =  params[:model2]
		self.parameters["model3"] =  params[:model3]
		self.parameters["material1"] =  params[:material1]
		self.parameters["material2"] =  params[:material2]
		self.parameters["material3"] =  params[:material3]
	end

	def login
		if self.parameters != nil
			email = Session.connection.quote(self.parameters["email"])
			password = Session.connection.quote(Digest::MD5.hexdigest(self.parameters["password"].to_s))
			@res = Session.connection.execute("SELECT IDU FROM credentials WHERE username = #{email} AND password = #{password}")
			if @res.count == 1
				self.user_id = @res.first[0].to_i
				return nil
			else
				return "E-mail or password entered incorrect. Please try again!"
			end
		end	
	end

	def create_user
		if self.parameters != nil
			@max_id = Session.connection.execute("SELECT MAX(IDU) FROM users")
			@max_id = @max_id.first[0].to_i
			idu = Session.connection.quote(@max_id+1)
			first_name = Session.connection.quote(self.parameters["first_name"])
			last_name = Session.connection.quote(self.parameters["last_name"])
			
			email = Session.connection.quote(self.parameters["email"])
			re_email = Session.connection.quote(self.parameters["re_email"])
			if email != re_email
				return "The provided email addresses did not match. Please try again!"
			end

			password = Session.connection.quote(Digest::MD5.hexdigest(self.parameters["password"].to_s))
			re_password = Session.connection.quote(Digest::MD5.hexdigest(self.parameters["re_password"].to_s))
			if password != re_password
				return "The provided passwords did not match. Please try again!"
			end
			
			@age = string_to_age(self.parameters["birthdate"])
			if @age < 0
				return "Please select your birthdate!"
			end
			birthdate = Session.connection.quote(self.parameters["birthdate"])
			
			sex = Session.connection.quote(self.parameters["gender"] == "1" ? 1 : 0)

			Session.connection.execute("INSERT INTO users VALUES(#{idu}, #{first_name}, #{last_name}, 0, b'#{sex}', #{email}, NULL, #{birthdate})")
			Session.connection.execute("INSERT INTO credentials VALUES(#{idu}, #{email}, #{password})")

			self.user_id = idu
			self.new_user = true
			return nil
		end
	end

	def string_to_age(string_birthdate)
		@birthdate = DateTime.parse(string_birthdate)
		@now = Time.now.utc.to_date
  		@age = @now.year - @birthdate.year - (@birthdate.to_date.change(:year => @now.year) > @now ? 1 : 0)
		return @age
	end	

	def change_password
		if self.parameters != nil
			idu = Session.connection.quote(self.user_id)
			
			old_password = Session.connection.quote(Digest::MD5.hexdigest(self.parameters["old_password"].to_s))
			@res = Session.connection.execute("SELECT * FROM credentials WHERE IDU = #{idu} AND password = #{old_password}")
			if @res.count != 1
				return "The entered old password is wrong. Please try again!"
			end

			password = Session.connection.quote(Digest::MD5.hexdigest(self.parameters["password"].to_s))
			re_password = Session.connection.quote(Digest::MD5.hexdigest(self.parameters["re_password"].to_s))
			if password != re_password
				return "The entered new passwords do not match. Please try again!"
			end 

			Session.connection.execute("UPDATE credentials SET password = #{password} WHERE IDU = #{idu}")			
			return nil
		end
	end

	def create_profile
		idu = Session.connection.quote(self.user_id)
		if self.parameters["color1"] == 0 and self.parameters["color2"] == 0 and self.parameters["color3"] == 0
			return "You have to select at least one preferred color!"
		end
		color = "'" + self.parameters["color1"].to_s + "," + self.parameters["color2"].to_s + "," + self.parameters["color3"].to_s + "'"
		
		if self.parameters["model1"] == 0 and self.parameters["model2"] == 0 and self.parameters["model3"] == 0
			return "You have to select at least one preferred model!"	
		end
		model = "'" + self.parameters["model1"].to_s + "," + self.parameters["model2"].to_s + "," + self.parameters["model3"].to_s + "'"
		
		if self.parameters["material1"] == 0 and self.parameters["material2"] == 0 and self.parameters["material3"] == 0
			return "You have to select at least one preferred material!"
		end
		material = "'" + self.parameters["material1"].to_s + "," + self.parameters["material2"].to_s + "," + self.parameters["material3"].to_s + "'"

		Session.connection.execute("INSERT INTO profiles VALUES(#{idu}, #{color}, #{material}, #{model})")
		return nil
	end
	
	def change_profile
		idu = Session.connection.quote(self.user_id)
		if self.parameters["color1"] == 0 and self.parameters["color2"] == 0 and self.parameters["color3"] == 0
			return "You have to select at least one preferred color!"
		end
		color = "'" + self.parameters["color1"].to_s + "," + self.parameters["color2"].to_s + "," + self.parameters["color3"].to_s + "'"
		
		if self.parameters["model1"].to_i == 0 and self.parameters["model2"].to_i == 0 and self.parameters["model3"].to_i == 0
			return "You have to select at least one preferred model!"	
		end
		model = "'" + self.parameters["model1"].to_s + "," + self.parameters["model2"].to_s + "," + self.parameters["model3"].to_s + "'"
		
		if self.parameters["material1"] == 0 and self.parameters["material2"] == 0 and self.parameters["material3"] == 0
			return "You have to select at least one preferred material!"
		end
		material = "'" + self.parameters["material1"].to_s + "," + self.parameters["material2"].to_s + "," + self.parameters["material3"].to_s + "'"

		Session.connection.execute("UPDATE profiles SET color_priority = #{color}, material_priority = #{material}, model_priority = #{model} WHERE idu = #{idu}")
		return nil	
	end

	def get_name(id)
		id = self.decrypt_id(id)
		idu = Session.connection.quote(id)
		@res = Session.connection.execute("SELECT first_name FROM users WHERE IDU = #{idu}")
		return @res.first[0].to_s
	end

	def get_last_name(id)
		id = self.decrypt_id(id)
		idu = Session.connection.quote(id)
		@res = Session.connection.execute("SELECT last_name FROM users WHERE IDU = #{idu}")
		return @res.first[0].to_s
	end

	def get_email(id)
		id = self.decrypt_id(id)
		idu = Session.connection.quote(id)
		@res = Session.connection.execute("SELECT email FROM users WHERE IDU = #{idu}")
		return @res.first[0].to_s
	end

	def get_gender(id)
		id = self.decrypt_id(id)
		idu = Session.connection.quote(id)
		@res = Session.connection.execute("SELECT sex+0 FROM users WHERE IDU = #{idu}")
		return @res.first[0].to_s == "1" ? "Female" : "Male"
	end

	def get_birthdate(id)
		id = self.decrypt_id(id)
		idu = Session.connection.quote(id)
		@res = Session.connection.execute("SELECT birthdate FROM users WHERE IDU = #{idu}")
		return @res.first[0].to_s
	end

	def get_profile_value(id, elem)
		id = self.decrypt_id(id)
		@property = elem[0..-2]		
		@val = elem[-1].chr.to_i
		
		idu = Session.connection.quote(id)
		@res = Session.connection.execute("SELECT " + @property + "_priority FROM profiles WHERE IDU = #{idu}")
		if @res.count == 1
			@str = @res.first[0].to_s
			@str = @str.split(",")
			return @str[@val-1].to_i
		end
	end

	def get_colors
		@res = Session.connection.execute("SELECT * FROM color_type")
		s = []
		@res.each do |row|
			s.append([row[1].to_s, row[0].to_i])
		end
		return s
	end

	def get_materials
		@res = Session.connection.execute("SELECT * FROM material_type")
		s = []
		@res.each do |row|
			s.append([row[1].to_s, row[0].to_i])
		end
		return s
	end

	def get_models
		@res = Session.connection.execute("SELECT * FROM model_type")
		s = []
		@res.each do |row|
			s.append([row[1].to_s, row[0].to_i])
		end
		return s
	end

	def get_user_id
		return self.encrypt_id(self.user_id)
	end

	def encrypt_id(id)		
		@rand = (0...24).map{ ('a'..'z').to_a[rand(26)] }.join
		rand = Session.connection.quote(@rand)
		idu = Session.connection.quote(id)

		Session.connection.execute("INSERT INTO current_users VALUES(#{idu},#{rand})")
		
		return @rand
	end

	def decrypt_id(str)
		begin
			rand = Session.connection.quote(str)
		
			@res = Session.connection.execute("SELECT ID FROM current_users WHERE token = #{rand}")
			if @res.count == 1
				return @res.first[0].to_i
			else
				return -1
			end
		rescue
		end
	end

	def profileExists?
		idu = Session.connection.quote(self.user_id)
		@res = Session.connection.execute("SELECT * FROM profiles WHERE IDU = #{idu}")
		if @res.count != 0
			return true
		else
			return false
		end
	end
	
	def new_user?
		return @new_user
	end

	def isOpen?
		return self.user_id != -1
	end

	def logout
		idu = Session.connection.quote(self.user_id)
		Session.connection.execute("DELETE FROM current_users WHERE ID = #{idu}")
		self.user_id = -1
	end
	
end
