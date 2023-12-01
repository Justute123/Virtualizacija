package com.example.springboottodoapplication.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;


@Controller
public class ApieController {
    @Autowired

    @GetMapping("/apie")
    public ModelAndView index(){
        ModelAndView modelAndView  = new ModelAndView("apie");
        return modelAndView;
    }
}
