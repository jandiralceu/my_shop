import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/products.dart';
import '../../Domain/Models/product.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  late Product _editedProduct;
  var _isInit = true;

  var initialValues = {
    'price': '',
    'title': '',
    'imageUrl': '',
    'description': '',
  };

  var urlPattern =
      r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _priceFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments;

      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context).findById(productId as String);

        initialValues['title'] = _editedProduct.title;
        initialValues['price'] = _editedProduct.price.toString();
        initialValues['description'] = _editedProduct.description;
        initialValues['imageUrl'] = '';

        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();

    if (isValid) {
      final productId = ModalRoute.of(context)?.settings.arguments;
      _form.currentState!.save();

      if (productId == null) {
        Provider.of<Products>(context, listen: false).addProduct(
          Product(
            id: DateTime.now().toString(),
            isFavorite: false,
            title: initialValues['title'] as String,
            description: initialValues['description'] as String,
            price: double.parse(initialValues['price'] as String),
            imageUrl: initialValues['imageUrl'] as String,
          ),
        );
      } else {
        Provider.of<Products>(context, listen: false).updateProduct(
            productId as String,
            Product(
              id: productId,
              isFavorite: _editedProduct.isFavorite,
              title: initialValues['title'] as String,
              description: initialValues['description'] as String,
              price: double.parse(initialValues['price'] as String),
              imageUrl: initialValues['imageUrl'] ?? _imageUrlController.text,
            ));
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: initialValues['title'],
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  decoration: const InputDecoration(labelText: 'Title'),
                  onSaved: (value) => setState(() {
                    initialValues['title'] = value ?? '';
                  }),
                  validator: (value) {
                    if (value == null) {
                      return 'Please, provide a value.';
                    }

                    if (value.isEmpty) {
                      return 'Please, provide a value.';
                    }

                    return null;
                  },
                ),
                TextFormField(
                  initialValue: initialValues['price'],
                  decoration: const InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value) => setState(() {
                    initialValues['price'] = value ?? '';
                  }),
                  validator: (value) {
                    if (value == null) {
                      return 'Please, provide a value.';
                    }

                    if (value.isEmpty) {
                      return 'Please, provide a value.';
                    }

                    if (double.tryParse(value) == null) {
                      return 'Please, enter a valid number.';
                    }

                    if (double.parse(value) <= 0) {
                      return 'Please, provide a number greater than 0.';
                    }

                    return null;
                  },
                ),
                TextFormField(
                  maxLines: 3,
                  initialValue: initialValues['description'],
                  focusNode: _descriptionFocusNode,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(labelText: 'Description'),
                  onSaved: (value) => setState(() {
                    initialValues['description'] = value ?? '';
                  }),
                  validator: (value) {
                    if (value == null) {
                      return 'Please, provide a value.';
                    }

                    if (value.isEmpty) {
                      return 'Please, provide a value.';
                    }

                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? const Text('Enter a Url')
                          : FittedBox(
                              child: Image.network(_imageUrlController.text),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        decoration:
                            const InputDecoration(labelText: 'Image URL'),
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onSaved: (value) => setState(() {
                          initialValues['imageUrl'] = value ?? '';
                        }),
                        validator: (value) {
                          if (value == null) {
                            return 'Please, provide a value.';
                          }

                          if (value.isEmpty) {
                            return 'Please, provide a value.';
                          }

                          return null;
                        },
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
