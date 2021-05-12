/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.example.APIJAVA.Clases;

import java.util.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.*; 
import org.springframework.web.bind.annotation.*;

/**
 *
 * @author monic
 */
@RestController
public class PattternController {
    @Autowired
    private PatternService service;
    
    @PostMapping("/patterns")
    public void add(@RequestBody Patterns pattern) {
        service.save(pattern);
    }
    
    @GetMapping("/patternsxd")
    public List<Patterns> list() {
        System.out.println("HELP");
        return service.listAll();
    }
    
    @GetMapping("/patterns/{id}")
    public ResponseEntity<Patterns> get(@PathVariable String id) {
    try {
        Patterns pattern = service.get(id);
        return new ResponseEntity<Patterns>(pattern, HttpStatus.OK);
    } catch (NoSuchElementException e) {
        return new ResponseEntity<Patterns>(HttpStatus.NOT_FOUND);
    }      
}
}
    
