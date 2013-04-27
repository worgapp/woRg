class WardrobeController < ApplicationController
	
	attr_accessor :parameters			# Variable params from views
	attr_accessor :user_id				# Current user id ( -1 if no user is logged in)
	attr_accessor :wardrobe_id			# Current wardrobe id ( -1 if no wardrobe is selected )

	def initialize
		self.parameters = {}
		self.user_id = -1
		self.wardrobe_id = -1
	end

	def set_data(params)
		self.user_id = self.decrypt_id(params[:user_id])
		self.parameters["name"] = params[:name]
	end

	def set_clothes_data(params)
		self.user_id = self.decrypt_id(params[:user_id])
		self.wardrobe_id = params[:wardrobe_id]
		self.parameters["type"] = params[:type]
		self.parameters["formal"] = params[:formal]
		self.parameters["primary_color"] = params[:primary_color]
		self.parameters["secondary_color"] = params[:secondary_color]
		self.parameters["primary_model"] = params[:primary_model]
		self.parameters["secondary_model"] = params[:secondary_model]
		self.parameters["primary_material"] = params[:primary_material]
		self.parameters["secondary_material"] = params[:secondary_material]
		self.parameters["photo"] = params[:photo]
		self.parameters["description"] = params[:description]
		self.parameters["rating"] = params[:rating]
	end

	def set_general_search_data(params)
		self.user_id = self.decrypt_id(params[:user_id])
		self.parameters["search_text"] = params[:search_text]
	end

	def set_search_data(params)
		self.user_id = self.decrypt_id(params[:user_id])
		self.parameters["formal"] = params[:formal]
		self.parameters["color"] = params[:color]
		self.parameters["material"] = params[:material]
		self.parameters["model"] = params[:model]
	end

	def set_final_data(params)
		self.set_search_data(params)
		self.parameters["list"] = params[:list]
	end

	def get_wardrobe_number(id)
		id = self.decrypt_id(id)
		idu = Session.connection.quote(id)
		@res = Session.connection.execute("SELECT COUNT(IDU) FROM wardrobe WHERE IDU = #{idu}")
		return @res.first[0].to_i
	end
	
	def get_wardrobe_name(idu, idw)
		idu = self.decrypt_id(idu)
		idu = Session.connection.quote(idu)
		idw = Session.connection.quote(idw)
		@res = Session.connection.execute("SELECT name FROM wardrobe WHERE IDU = #{idu} AND IDW = #{idw}")
		return @res.first[0].to_s
	end

	def get_wardrobe_list(idu)
		idu = self.decrypt_id(idu)
		idu = Session.connection.quote(idu)
		
		@res = Session.connection.execute("SELECT IDW, name FROM wardrobe WHERE IDU = #{idu}")
		return @res
	end

	def get_clothes_type
		@res = Session.connection.execute("SELECT * FROM clothes_type")
		s = []
		@res.each do |row|
			s.append([row[1].to_s, row[0].to_i])
		end
		return s
	end
	
	def get_type_by_id(id)
		id = Session.connection.quote(id)

		@res = Session.connection.execute("SELECT name FROM clothes_type WHERE ID = #{id}")
		if @res.count == 1
			return @res.first[0].to_s
		end
	end

	def get_color_by_id(id)
		id = Session.connection.quote(id)

		@res = Session.connection.execute("SELECT name FROM color_type WHERE ID = #{id}")
		if @res.count == 1
			return @res.first[0].to_s
		end
	end

	def get_model_by_id(id)
		id = Session.connection.quote(id)

		@res = Session.connection.execute("SELECT name FROM model_type WHERE ID = #{id}")
		if @res.count == 1
			return @res.first[0].to_s
		end
	
	end

	def get_material_by_id(id)
		id = Session.connection.quote(id)

		@res = Session.connection.execute("SELECT name FROM material_type WHERE ID = #{id}")
		if @res.count == 1
			return @res.first[0].to_s
		end
	
	end

	def get_formal_by_id(id)
		id = Session.connection.quote(id)

		@res = Session.connection.execute("SELECT name FROM formality_type WHERE ID = #{id}")
		if @res.count == 1
			return @res.first[0].to_s
		end
	end

	def get_clothes_list(idu, idw)
		idu = self.decrypt_id(idu)
		idu = Session.connection.quote(idu)
		idw = Session.connection.quote(idw)
		
		@res = Session.connection.execute("SELECT IDC, type, primary_color, primary_material, primary_model, description, formal, photo FROM clothes WHERE IDU = #{idu} AND IDW = #{idw}")
		return @res		
	end

	def get_number_top_bottom(res, top)
		@top_count = 0
		@bottom_count = 0

		res.each do |elem|
			if isTop?(elem[1].to_i)
				@top_count += 1
			else
				@bottom_count += 1
			end
		end
		
		if top
			return @top_count
		else
			return @bottom_count
		end
	end
	
	def get_number_of_top(res)
		@count = 0
		res.each do |elem|
			if isTop?(elem[1].to_i)
				@count += 1
			end
		end

		return @count
	end

	def create_wardrobe
		if self.parameters != nil
			idu = Session.connection.quote(self.user_id)
			
			@idw = Session.connection.execute("SELECT MAX(IDW) FROM wardrobe WHERE IDU = #{idu}")
			@idw = @idw.first[0].to_i
			idw = Session.connection.quote(@idw+1)
			
			name = Session.connection.quote(self.parameters["name"])			
			
			Session.connection.execute("INSERT INTO wardrobe VALUES(#{idw}, #{idu}, #{name})")
			return @idw+1
		end
	end

	def delete_wardrobe(idu, idw)
		idu = self.decrypt_id(idu)
		idu = Session.connection.quote(idu)
		idw = Session.connection.quote(idw)
	
		Session.connection.execute("DELETE FROM clothes WHERE IDU = #{idu} AND IDW = #{idw}")
		Session.connection.execute("DELETE FROM wardrobe WHERE IDU = #{idu} AND IDW = #{idw}")
	end

	def general_search
		idu = Session.connection.quote(self.user_id)
		
		text = Session.connection.quote("%"+self.parameters["search_text"].to_s+"%")
		
		color = "(SELECT ID FROM color_type WHERE name LIKE #{text})"
		model = "(SELECT ID FROM model_type WHERE name LIKE #{text})"
		material = "(SELECT ID FROM material_type WHERE name LIKE #{text})"
		clothes = "(SELECT ID FROM clothes_type WHERE name LIKE #{text})"
		formal = "(SELECT ID FROM formality_type WHERE name LIKE #{text})"

		@res = Session.connection.execute("SELECT IDC, type, primary_color, primary_material, primary_model, description, formal, photo FROM clothes WHERE IDU = #{idu} AND (type IN #{clothes} OR formal IN #{formal} OR primary_color IN #{color} OR secondary_color IN #{color} OR primary_model IN #{model} OR secondary_model IN #{model} OR primary_material IN #{material} OR secondary_material IN #{material})")

		return @res
	end

	def search
		idu = Session.connection.quote(self.user_id)

		formal = Session.connection.quote(self.parameters["formal"])
	
		if self.parameters["color"].to_i != 0
			color = Session.connection.quote(self.parameters["color"])
		else
			color = ""
		end

		if self.parameters["model"].to_i != 0
			model = Session.connection.quote(self.parameters["model"])
		else
			model = ""
		end

		if self.parameters["material"].to_i != 0
			material = Session.connection.quote(self.parameters["material"])
		else
			material = ""
		end

		if color != ""
			if model != ""
				if material != ""
				# color, model, material
					@res = Session.connection.execute("SELECT IDC, type, primary_color, secondary_color, primary_material, secondary_material, primary_model, secondary_model, description, photo FROM clothes WHERE IDU = #{idu} AND formal = #{formal} AND (primary_color = #{color} OR secondary_color = #{color}) AND (primary_model = #{model} OR secondary_model = #{model}) AND (primary_material = #{material} OR secondary_material = #{material})")
				else
				# color, model
					@res = Session.connection.execute("SELECT IDC, type, primary_color, secondary_color, primary_material, secondary_material, primary_model, secondary_model, description, photo FROM clothes WHERE IDU = #{idu} AND formal = #{formal} AND (primary_color = #{color} OR secondary_color = #{color}) AND (primary_model = #{model} OR secondary_model = #{model})")
				end
			else
				if material != ""
				# color, material
					@res = Session.connection.execute("SELECT IDC, type, primary_color, secondary_color, primary_material, secondary_material, primary_model, secondary_model, description, photo FROM clothes WHERE IDU = #{idu} AND formal = #{formal} AND (primary_color = #{color} OR secondary_color = #{color}) AND (primary_material = #{material} OR secondary_material = #{material})")
				else
				# color
					@res = Session.connection.execute("SELECT IDC, type, primary_color, secondary_color, primary_material, secondary_material, primary_model, secondary_model, description, photo FROM clothes WHERE IDU = #{idu} AND formal = #{formal} AND (primary_color = #{color} OR secondary_color = #{color})")
				end
			end
		else
			if model != ""
				if material != ""
				# model, material
					@res = Session.connection.execute("SELECT IDC, type, primary_color, secondary_color, primary_material, secondary_material, primary_model, secondary_model, description, photo FROM clothes WHERE IDU = #{idu} AND formal = #{formal} AND (primary_model = #{model} OR secondary_model = #{model}) AND (primary_material = #{material} OR secondary_material = #{material})")
				else
				# model
					@res = Session.connection.execute("SELECT IDC, type, primary_color, secondary_color, primary_material, secondary_material, primary_model, secondary_model, description, photo FROM clothes WHERE IDU = #{idu} AND formal = #{formal} AND (primary_model = #{model} OR secondary_model = #{model})")
				end
			else
				if material != ""
				# material
					@res = Session.connection.execute("SELECT IDC, type, primary_color, secondary_color, primary_material, secondary_material, primary_model, secondary_model, description, photo FROM clothes WHERE IDU = #{idu} AND formal = #{formal} AND (primary_material = #{material} OR secondary_material = #{material})")
				else
				# none
					@res = Session.connection.execute("SELECT IDC, type, primary_color, secondary_color, primary_material, secondary_material, primary_model, secondary_model, description, photo FROM clothes WHERE IDU = #{idu} AND formal = #{formal}")
				end
			end
		end

		return @res
	end

	def final_search
		@res = self.search
		
		@new_list = []
		@list = self.parameters["list"].split(',')
		@list.each do |elem|
			@new_list.push(elem.to_i)
		end

		@final_res = []
		@res.each do |elem|
			if @new_list.include?(elem[0].to_i)
				@final_res.push(elem)
			end
		end
		
		return @final_res
	end

	def delete_clothes(idu, idw, idc)
		idu = self.decrypt_id(idu)
		idu = Session.connection.quote(idu)
		idw = Session.connection.quote(idw)
		idc = Session.connection.quote(idc)
	
		Session.connection.execute("DELETE FROM clothes WHERE IDU = #{idu} AND IDW = #{idw} AND IDC = #{idc}")
	end

	def add_clothes
		if self.parameters != nil
			@idc = Session.connection.execute("SELECT MAX(IDC) FROM clothes")
			@idc = @idc.first[0].to_i+1
			idc = Session.connection.quote(@idc)
			
			idu = Session.connection.quote(self.user_id)
			idw = Session.connection.quote(self.wardrobe_id)
			
			if self.parameters["type"].to_i == 0
				return "Please select the cloth type for this item!"
			end
			type = Session.connection.quote(self.parameters["type"])
			
			formal = Session.connection.quote(self.parameters["formal"])
			rating = Session.connection.quote(self.parameters["rating"])

			if self.parameters["primary_color"].to_i == 0
				return "Please select the primary color!"
			end
			primary_color = Session.connection.quote(self.parameters["primary_color"])
			secondary_color = Session.connection.quote(self.parameters["secondary_color"])
			
			if self.parameters["primary_model"].to_i == 0
				return "Please select the primary model!"
			end
			primary_model = Session.connection.quote(self.parameters["primary_model"])
			secondary_model = Session.connection.quote(self.parameters["secondary_model"])
			
			if self.parameters["primary_material"].to_i == 0
				return "Please select the primary material!"
			end
			primary_material = Session.connection.quote(self.parameters["primary_material"])
			secondary_material = Session.connection.quote(self.parameters["secondary_material"])
			
			description = Session.connection.quote(self.parameters["description"])
			
			file = self.parameters["photo"]
			if file != nil			
				@filename = (0...24).map{ ('a'..'z').to_a[rand(26)] }.join + ".jpg"
				@directory = Dir.pwd + "/public/imgs/"			
				path = File.join(@directory, @filename)
				File.open(path, "wb") {|f| f.write(file.read) }
				@directory1 = "/imgs/"
				path = Session.connection.quote(File.join(@directory1, @filename))
			else
				path = Session.connection.quote("http://www.placehold.it/200x150/EFEFEF/AAAAAA&text=no+image")
			end

			Session.connection.execute("INSERT INTO clothes VALUES(#{idc}, #{idu}, #{idw}, b'1', #{type}, #{formal}, #{rating}, #{primary_material}, #{secondary_material}, #{primary_color}, #{secondary_color}, #{primary_model}, #{secondary_model}, #{description}, #{path})")

			return nil
		end
	end

	def isTop?(type_id)
		id = Session.connection.quote(type_id)

		@res = Session.connection.execute("SELECT top+0 FROM clothes_type WHERE ID = #{id}")
		if @res.first[0].to_i == 1
			return true
		else
			return false
		end
	end

	def outfit_possible?(results)
		if results.count == 0
			return false
		else
			@hasTop = false
			@hasBottom = false
			results.each do |cloth|
				if self.isTop?(cloth[1].to_i)
					@hasTop = true
				else
					@hasBottom = true
				end
			end

			return @hasTop & @hasBottom
		end
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
	
end
