<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'image_path',
    ];

    protected $hidden = [
        'created_at',
        'updated_at',
    ];

    protected $with = ['shops'];

    protected $appends = [];

    public function shops()
    {
        return $this->belongsToMany(Shop::class)->select('shops.id', 'shops.name');
    }
}
