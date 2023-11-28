package com.example.springboottodoapplication.controllers;

import com.example.springboottodoapplication.services.OrderItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;


@Controller
public class IndexController {
    @Autowired

    @GetMapping("/")
    public ModelAndView index(){
        ModelAndView modelAndView  = new ModelAndView("index");
        return modelAndView;
    }
}
