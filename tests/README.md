# [Xindi Unit Tests] (http://www.getxindi.com/)

## Introduction

The test suite uses:
1. unit testing to test entities and gateways
2. integration testing to test services

## What is a Unit Test?

A unit test is a test written by the programmer to verify that a relatively small piece of code is doing what it is intended to do. 
They are narrow in scope, they should be easy to write and execute, and their effectiveness depends on what the programmer considers 
to be useful. The tests are intended for the use of the programmer, they are not directly useful to anybody else, though, if they do 
their job, testers and users downstream should benefit from seeing less bugs.

## What is an Integration Test?

An integration test is done to demonstrate that different pieces of the system work together. Integration tests cover whole applications, 
and they require much more effort to put together. They usually require resources like database instances and hardware to be allocated for 
them. The integration tests do a more convincing job of demonstrating the system works (especially to non-programmers) than a set of unit 
tests can, at least to the extent the integration test environment resembles production.