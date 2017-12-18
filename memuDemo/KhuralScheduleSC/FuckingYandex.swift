//
//  FuckingYandex.swift
//  memuDemo
//
//  Created by Dugar Badagarov on 02/10/2017.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit

class FuckingYandex: UIViewController {

    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()                
        
        webView.scalesPageToFit = true
    webView.loadHTMLString("<iframe src=\"https://money.yandex.ru/quickpay/shop-widget?writer=seller&targets=%D0%9F%D0%BE%D0%B6%D0%B5%D1%80%D1%82%D0%B2%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5%20%D0%B4%D0%BB%D1%8F%20%D0%91%D1%83%D0%B4%D0%B4%D0%B8%D0%B9%D1%81%D0%BA%D0%BE%D0%B9%20%D1%82%D1%80%D0%B0%D0%B4%D0%B8%D1%86%D0%B8%D0%BE%D0%BD%D0%BD%D0%BE%D0%B9%20%D0%A1%D0%B0%D0%BD%D0%B3%D1%85%D0%B8%20%D0%A0%D0%BE%D1%81%D1%81%D0%B8%D0%B8&targets-hint=&default-sum=\(StringSumm)&button-text=14&payment-type-choice=on&hint=&successURL=&quickpay=shop&account=410015712918249\" width=\"350\" height=\"213\" frameborder=\"0\" allowtransparency=\"true\" scrolling=\"no\"></iframe>", baseURL: nil)
        
    //webView.loadHTMLString("<form method=\"POST\" action=\"https://money.yandex.ru/quickpay/confirm.xml\">    <input type=\"hidden\" name=\"receiver\" value=\"410015712918249\">    <input type=\"hidden\" name=\"formcomment\" value=\"Проект «Железный человек»: реактор холодного ядерного синтеза\">    <input type=\"hidden\" name=\"short-dest\" value=\"Проект «Железный человек»: реактор холодного ядерного синтеза\">    <input type=\"hidden\" name=\"label\" value=\"$order_id\">    <input type=\"hidden\" name=\"quickpay-form\" value=\"donate\">    <input type=\"hidden\" name=\"targets\" value=\"транзакция {order_id}\">    <input type=\"hidden\" name=\"sum\" value=\"4568.25\" data-type=\"number\">    <input type=\"hidden\" name=\"comment\" value=\"Хотелось бы получить дистанционное управление.\">    <input type=\"hidden\" name=\"need-fio\" value=\"true\">    <input type=\"hidden\" name=\"need-email\" value=\"true\">    <input type=\"hidden\" name=\"need-phone\" value=\"false\">    <input type=\"hidden\" name=\"need-address\" value=\"false\">    <label><input type=\"radio\" name=\"paymentType\" value=\"PC\">Яндекс.Деньгами</label>    <label><input type=\"radio\" name=\"paymentType\" value=\"AC\">Банковской картой</label>    <input type=\"submit\" value=\"Перевести\"></form>", baseURL: nil)    
        
        
    //webView.loadRequest(URLRequest(url: URL(string: "https://money.yandex.ru/quickpay/shop-widget?writer=seller&targets=%D0%9F%D0%BE%D0%B6%D0%B5%D1%80%D1%82%D0%B2%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5%20%D0%B4%D0%BB%D1%8F%20%D0%91%D1%83%D0%B4%D0%B4%D0%B8%D0%B9%D1%81%D0%BA%D0%BE%D0%B9%20%D1%82%D1%80%D0%B0%D0%B4%D0%B8%D1%86%D0%B8%D0%BE%D0%BD%D0%BD%D0%BE%D0%B9%20%D0%A1%D0%B0%D0%BD%D0%B3%D1%85%D0%B8%20%D0%A0%D0%BE%D1%81%D1%81%D0%B8%D0%B8&targets-hint=&default-sum=\(StringSumm)&button-text=14&hint=&successURL=&quickpay=shop&account=410015712918249")!))
        
        
        DispatchQueue.main.async(execute: {
            while (self.webView.isLoading) {}            
            print (self.webView.frame.width)
            print (self.webView.bounds.width)
            print (self.webView.contentScaleFactor)
            
            return
        })
        
        print (UIApplication.shared.keyWindow?.frame)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
//89082087328
    }

}
