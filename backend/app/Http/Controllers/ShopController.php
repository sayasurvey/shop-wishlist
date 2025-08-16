<?php

namespace App\Http\Controllers;

use App\Models\Shop;
use Illuminate\Http\Request;

class ShopController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $shops = Shop::select('id', 'name')->get();
        return response()->json($shops);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
        ]);

        $shop = Shop::create($request->only(['name']));

        return response()->json(['message' => '店舗の登録が完了しました'], 201);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Shop $shop)
    {
        $request->validate([
            'name' => 'required|string|max:255',
        ]);

        $shop->update($request->only(['name']));

        return response()->json(['message' => '更新が完了しました']);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Shop $shop)
    {
        $shop->delete();
        return response()->json(['message' => '店舗を削除しました。']);
    }

    /**
     * Get products for a specific shop.
     */
    public function products(Shop $shop)
    {
        $products = $shop->products;
        return response()->json($products);
    }
}
