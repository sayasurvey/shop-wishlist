import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const ShopProductsApp());
}

class ShopProductsApp extends StatelessWidget {
  const ShopProductsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'お店毎商品管理',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ShopListScreen(),
    );
  }
}

class ShopListScreen extends StatefulWidget {
  const ShopListScreen({super.key});

  @override
  State<ShopListScreen> createState() => _ShopListScreenState();
}

class _ShopListScreenState extends State<ShopListScreen> {
  List<Map<String, dynamic>> shops = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadShops();
  }

  Future<void> loadShops() async {
    try {
      // TODO: Laravel APIからお店一覧を取得
      // 現在はサンプルデータを表示
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        shops = [
          {'id': 1, 'name': 'サンプル書店', 'product_count': 3},
          {'id': 2, 'name': 'おしゃれ雑貨店', 'product_count': 5},
          {'id': 3, 'name': 'カフェ用品専門店', 'product_count': 2},
        ];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('データの読み込みに失敗しました: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('お店一覧'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              loadShops();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : shops.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.store, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('お店が登録されていません'),
                      SizedBox(height: 8),
                      Text('商品を登録してお店を作成してください'),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: shops.length,
                  itemBuilder: (context, index) {
                    final shop = shops[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.store),
                        ),
                        title: Text(
                          shop['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('商品数: ${shop['product_count']}個'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductListScreen(shop: shop),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProductRegistrationScreen(),
            ),
          );
        },
        tooltip: '商品登録',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProductListScreen extends StatefulWidget {
  final Map<String, dynamic> shop;

  const ProductListScreen({super.key, required this.shop});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  // サンプル商品データ
  static const Map<int, List<Map<String, dynamic>>> shopProducts = {
    1: [ // サンプル書店の商品
      {
        'id': 1,
        'name': '村上春樹 - ノルウェイの森',
        'description': '恋愛小説の名作',
        'price': 1200,
        'image_path': null,
      },
      {
        'id': 2,
        'name': '東野圭吾 - 容疑者Xの献身',
        'description': 'ミステリー小説',
        'price': 1100,
        'image_path': null,
      },
      {
        'id': 3,
        'name': '湊かなえ - 告白',
        'description': 'サスペンス小説',
        'price': 980,
        'image_path': null,
      },
    ],
    2: [ // おしゃれ雑貨店の商品
      {
        'id': 4,
        'name': 'ナチュラル木製トレー',
        'description': 'シンプルで使いやすいトレー',
        'price': 2800,
        'image_path': null,
      },
      {
        'id': 5,
        'name': 'アロマキャンドル',
        'description': 'リラックス効果のある香り',
        'price': 1500,
        'image_path': null,
      },
      {
        'id': 6,
        'name': 'マグカップセット',
        'description': 'ペアマグカップ',
        'price': 3200,
        'image_path': null,
      },
      {
        'id': 7,
        'name': 'フェイクグリーン',
        'description': '手入れ不要の観葉植物',
        'price': 2100,
        'image_path': null,
      },
      {
        'id': 8,
        'name': 'ハンドメイドコースター',
        'description': '天然素材のコースター',
        'price': 800,
        'image_path': null,
      },
    ],
    3: [ // カフェ用品専門店の商品
      {
        'id': 9,
        'name': 'エスプレッソマシン',
        'description': '本格的なエスプレッソが作れる',
        'price': 45000,
        'image_path': null,
      },
      {
        'id': 10,
        'name': 'コーヒーミル',
        'description': '手動式のコーヒーミル',
        'price': 8500,
        'image_path': null,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      // TODO: Laravel APIから商品一覧を取得
      // 現在はサンプルデータを表示
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        products = shopProducts[widget.shop['id']] ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('商品データの読み込みに失敗しました: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('${widget.shop['name']} - 商品一覧'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              loadProducts();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inventory, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text('${widget.shop['name']}に商品が登録されていません'),
                      const SizedBox(height: 8),
                      const Text('商品を追加してください'),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(
                                product: product,
                                shop: widget.shop,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 商品画像エリア
                            Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: product['image_path'] != null
                                  ? ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                      child: Image.network(
                                        product['image_path'],
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.broken_image, 
                                                     size: 40, 
                                                     color: Colors.grey),
                                                SizedBox(height: 4),
                                                Text('No Image',
                                                     style: TextStyle(
                                                       color: Colors.grey,
                                                       fontSize: 12,
                                                     )),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : const Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.image_not_supported, 
                                               size: 40, 
                                               color: Colors.grey),
                                          SizedBox(height: 4),
                                          Text('No Image',
                                               style: TextStyle(
                                                 color: Colors.grey,
                                                 fontSize: 12,
                                                 fontWeight: FontWeight.w500,
                                               )),
                                        ],
                                      ),
                                    ),
                            ),
                            // 商品情報エリア
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                product['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductRegistrationScreen(selectedShop: widget.shop),
            ),
          );
        },
        tooltip: '商品追加',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  final Map<String, dynamic> shop;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.shop,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(product['name']),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('商品を共有')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 商品画像エリア
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: product['image_path'] != null
                  ? Image.network(
                      product['image_path'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image, size: 64, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('画像の読み込みに失敗しました'),
                            ],
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 64, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('画像なし', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
            ),
            
            // 商品情報エリア
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 商品名
                  Text(
                    product['name'],
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  
                  // 店舗名
                  Row(
                    children: [
                      Icon(Icons.store, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        shop['name'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // 価格
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '¥${product['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // 商品説明
                  if (product['description'] != null) ...[
                    Text(
                      '商品説明',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        product['description'],
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // 商品情報
                  Text(
                    '商品情報',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow('商品ID', product['id'].toString()),
                        const Divider(),
                        _buildInfoRow('取扱店舗', shop['name']),
                        if (product['category'] != null) ...[
                          const Divider(),
                          _buildInfoRow('カテゴリ', product['category']),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${product['name']}をお気に入りに追加')),
          );
        },
        icon: const Icon(Icons.favorite_border),
        label: const Text('お気に入り'),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

class ProductRegistrationScreen extends StatefulWidget {
  final Map<String, dynamic>? selectedShop;

  const ProductRegistrationScreen({super.key, this.selectedShop});

  @override
  State<ProductRegistrationScreen> createState() => _ProductRegistrationScreenState();
}

class _ProductRegistrationScreenState extends State<ProductRegistrationScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final List<Map<String, dynamic>> _selectedShops = [];
  final List<Map<String, dynamic>> _availableShops = [
    {'id': 1, 'name': 'サンプル書店'},
    {'id': 2, 'name': 'おしゃれ雑貨店'},
    {'id': 3, 'name': 'カフェ用品専門店'},
  ];
  bool _isLoading = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.selectedShop != null) {
      _selectedShops.add(widget.selectedShop!);
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    super.dispose();
  }

  void _toggleShopSelection(Map<String, dynamic> shop) {
    setState(() {
      final index = _selectedShops.indexWhere((s) => s['id'] == shop['id']);
      if (index >= 0) {
        _selectedShops.removeAt(index);
      } else {
        _selectedShops.add(shop);
      }
    });
  }

  bool _isShopSelected(Map<String, dynamic> shop) {
    return _selectedShops.any((s) => s['id'] == shop['id']);
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('画像の選択に失敗しました: $e')),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('カメラで撮影'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('ギャラリーから選択'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_selectedImage != null)
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('画像を削除'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedImage = null;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _registerProduct() async {
    if (_productNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('商品名を入力してください')),
      );
      return;
    }

    if (_selectedShops.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('販売店を選択してください')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_productNameController.text}を登録しました'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('登録に失敗しました: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('商品登録'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _registerProduct,
            child: _isLoading 
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('登録', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '商品画像',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _showImageSourceDialog,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[50],
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'タップして画像を選択',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'カメラ撮影またはギャラリーから選択',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            Text(
              '商品名 *',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _productNameController,
              decoration: const InputDecoration(
                hintText: '商品名を入力してください',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.shopping_bag),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            
            const SizedBox(height: 24),
            
            Text(
              '販売店 * (複数選択可)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: _availableShops.map((shop) {
                  final isSelected = _isShopSelected(shop);
                  return InkWell(
                    onTap: () => _toggleShopSelection(shop),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[200]!,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                            color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.store, size: 20, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              shop['name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            
            if (_selectedShops.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '選択された販売店 (${_selectedShops.length}店舗)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: _selectedShops.map((shop) {
                        return Chip(
                          avatar: const Icon(Icons.store, size: 16),
                          label: Text(shop['name']),
                          onDeleted: () => _toggleShopSelection(shop),
                          deleteIcon: const Icon(Icons.close, size: 18),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _registerProduct,
                icon: _isLoading 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add_shopping_cart),
                label: Text(_isLoading ? '登録中...' : '商品を登録'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}