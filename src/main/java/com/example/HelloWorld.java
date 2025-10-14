package com.example;

/**
 * A simple Hello World application that demonstrates basic Java functionality.
 * This class will be compiled, containerized, and deployed using Docker.
 */
public class HelloWorld {
    
    /**
     * Main method that serves as the entry point for the application.
     * Prints "Hello World" to the console.
     * 
     * @param args Command line arguments (not used in this application)
     */
    public static void main(String[] args) {
        System.out.println("Hello World");
        System.out.println("Application started successfully!");
        System.out.println("Running from Docker container...");
    }
}