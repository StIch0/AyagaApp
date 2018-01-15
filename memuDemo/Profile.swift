//
//  Profile.swift
//  appAyaga
//
//  Created by Pavel Burdukovskii on 09/12/17.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import Foundation
class Profile {
    var login: String = ""
    var pswd: String = ""
    var name: String = ""
    var serName: String = ""
    var phone: String = ""
    var city: String = ""
    var id: Int = 0
    var sign: Bool = false
    var sub_num: String = ""
    var birth_date :String = "" 
    private init (){}
    func setData(login: String, pswd: String, name: String, serName: String, phone: String, city: String,birth_date: String, id: Int){
        
        self.login=login
        self.pswd=pswd
        self.name=name
        self.serName=serName
        self.phone=phone
        self.city=city
        self.id=id
        self.birth_date = birth_date

    }
    func Save (){
        let defaults = UserDefaults.standard
        defaults.set(login, forKey: "login")
        defaults.set(pswd, forKey: "pswd")
        defaults.set(name, forKey: "name")
        defaults.set(serName, forKey: "serName")
        defaults.set(phone, forKey: "phone")
        defaults.set(city, forKey: "city")
        defaults.set(id, forKey: "id")
        defaults.set(sign, forKey: "sign")
        defaults.set(birth_date, forKey: "birth_date")
        defaults.set(sub_num, forKey: "sub_num")
    }
    public static let shared = Profile()

}
