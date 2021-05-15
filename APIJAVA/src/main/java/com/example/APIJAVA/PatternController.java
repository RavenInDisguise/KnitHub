/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.example.APIJAVA;

import java.util.*;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.http.*; 
import java.util.List;
import java.util.NoSuchElementException;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 *
 * @author monic
 */
@RestController
@RequestMapping("/knithub")
public class PatternController {
    @Autowired
    PatternService service;
    
    @GetMapping("/patterns")
    public ResponseEntity<List<Patterns>> list() {
        List<Patterns> lista = service.listSalePatterns();
        return new ResponseEntity(lista,HttpStatus.OK);
    }
    @PostMapping("/add/patterns")
    public ResponseEntity<?> generatePatterns(@RequestBody Patterns pattern){
        service.generatePatterns(pattern);
        return new ResponseEntity("Pattern saved.", HttpStatus.CREATED);
    }

    /*@PostMapping("/add")
    public void add(@RequestBody Patterns Patterns) {
        service.save(Patterns);
    }
    
    @GetMapping("/")
    public List<Patterns> list() {
        return service.listAll();
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<Patterns> get(@PathVariable String id) {
    try {
        Patterns Patterns = service.get(id);
        return new ResponseEntity<Patterns>(Patterns, HttpStatus.OK);
    } catch (NoSuchElementException e) {
        return new ResponseEntity<Patterns>(HttpStatus.NOT_FOUND);
    }     
} */
}
    
