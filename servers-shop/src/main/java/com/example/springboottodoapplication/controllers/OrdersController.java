package com.example.springboottodoapplication.controllers;

import com.example.springboottodoapplication.services.OrderItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class OrdersController {
    @Autowired
    private OrderItemService orderItemService;

    @GetMapping("/orders")
    public ModelAndView index(){
        ModelAndView modelAndView  = new ModelAndView("orders");
        modelAndView.addObject("orderItems", orderItemService.getAll());
        return modelAndView;
    }
}
