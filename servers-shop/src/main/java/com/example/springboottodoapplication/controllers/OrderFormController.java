package com.example.springboottodoapplication.controllers;

import com.example.springboottodoapplication.models.OrderItem;
import com.example.springboottodoapplication.services.OrderItemService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.Banner;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
@Controller
public class OrderFormController {
    @Autowired
    private OrderItemService orderItemService;

    @GetMapping("/create-order")
    public String showCreateForm(OrderItem orderItem){
        return "new-order-item";
    }

    @PostMapping("/order")
    public String createOrderItem(@Valid OrderItem orderItem, BindingResult result, Model model){
        orderItemService.save(orderItem);
        return "redirect:/orders";
    }

    @GetMapping("/delete/{id}")
    public String deleteOrderItem(@PathVariable("id") Long id, Model model){
        OrderItem orderItem = orderItemService
                .getById(id)
                .orElseThrow(() -> new IllegalArgumentException("OrderItem id" + id + " not found"));
        orderItemService.delete(orderItem);
        return "redirect:/orders";
    }
}
