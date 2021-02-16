class User < ApplicationRecord
    include ActiveModel::AttributeMethods
    #attr_accessor :name, :email, :password, :password_repeat
end
