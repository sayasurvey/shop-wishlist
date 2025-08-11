<?php

use App\Http\Controllers\AuthController;
// use App\Http\Controllers\ShopController;
// use App\Http\Controllers\ProductController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::post('/users/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/users', [AuthController::class, 'user']);
    
    // // Shop routes
    // Route::apiResource('shops', ShopController::class);
    // Route::get('shops/{shop}/products', [ShopController::class, 'products']);
    
    // // Product routes
    // Route::apiResource('products', ProductController::class);
});
