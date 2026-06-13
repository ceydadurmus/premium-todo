import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import '../widgets/add_task_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Başlangıç için birkaç örnek görev ekliyoruz
  final List<TodoItem> _todoItems = [
    TodoItem(
      id: '1',
      title: 'Flutter Todo uygulamasının arayüzünü bitir',
      isCompleted: true,
      category: TodoCategory.work,
      date: DateTime.now(),
    ),
    TodoItem(
      id: '2',
      title: 'Akşam yürüyüşü yap ve su iç',
      isCompleted: false,
      category: TodoCategory.health,
      date: DateTime.now(),
    ),
    TodoItem(
      id: '3',
      title: 'Haftalık market alışverişi listesini hazırla',
      isCompleted: false,
      category: TodoCategory.shopping,
      date: DateTime.now().add(const Duration(days: 1)),
    ),
  ];

  // Filtreleme durumu (null = Hepsi demektir)
  TodoCategory? _activeFilter;

  // Yeni görev ekleme fonksiyonu
  void _addNewTask(String title, TodoCategory category, DateTime date) {
    final newTodo = TodoItem(
      id: DateTime.now().toString(),
      title: title,
      category: category,
      date: date,
    );

    setState(() {
      _todoItems.add(newTodo);
    });
  }

  // Görevi silme fonksiyonu
  void _deleteTask(String id) {
    setState(() {
      _todoItems.removeWhere((item) => item.id == id);
    });
  }

  // Görev durumunu tamamlama/geri alma fonksiyonu
  void _toggleTaskStatus(String id) {
    setState(() {
      final index = _todoItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        _todoItems[index].isCompleted = !_todoItems[index].isCompleted;
      }
    });
  }

  // Görev ekleme BottomSheet'ini açma fonksiyonu
  void _showAddTaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Klavyenin görünümü engellemesini önler
      backgroundColor: Colors.transparent, // Köşelerin yuvarlak görünmesi için transparent yapıyoruz
      builder: (_) {
        return AddTaskBottomSheet(onAddTask: _addNewTask);
      },
    );
  }

  // İlerleme yüzdesini hesaplayan yardımcı fonksiyon
  double _calculateProgress() {
    if (_todoItems.isEmpty) return 0.0;
    final completedCount = _todoItems.where((item) => item.isCompleted).length;
    return completedCount / _todoItems.length;
  }

  // Belirli bir kategorideki görev sayısını döndürür
  int _getTaskCountForCategory(TodoCategory category) {
    return _todoItems.where((item) => item.category == category).length;
  }

  @override
  Widget build(BuildContext context) {
    // Aktif filtreye göre listemizi filtreliyoruz
    final filteredTodos = _activeFilter == null
        ? _todoItems
        : _todoItems.where((item) => item.category == _activeFilter).toList();

    final progress = _calculateProgress();
    final progressPercentage = (progress * 100).toInt();

    // Türkçe ay ve gün formatı için basit bir yardımcı
    final daysOfWeek = ['Pazar', 'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi'];
    final months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    final now = DateTime.now();
    final formattedDate = '${now.day} ${months[now.month - 1]} ${daysOfWeek[now.weekday % 7]}';

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Slate 900 - Premium koyu arka plan
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst Kısım: Başlık ve Tarih
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Yapılacaklar 👋',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  // Temizlik sıfırlama butonu (opsiyonel)
                  if (_todoItems.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.cleaning_services_rounded, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _todoItems.removeWhere((item) => item.isCompleted);
                        });
                      },
                      tooltip: 'Tamamlananları Temizle',
                    ),
                ],
              ),
            ),

            // İlerleme Kartı (Gradient ve cam efekti)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1E293B),
                      const Color(0xFF1E293B).withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.05),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Günlük İlerleme',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '%$progressPercentage',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B82F6), // Neon Mavi
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Özelleştirilmiş Linear Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 10,
                        width: double.infinity,
                        color: const Color(0xFF0F172A),
                        child: Stack(
                          children: [
                            AnimatedFractionallySizedBox(
                              duration: const Duration(milliseconds: 400),
                              widthFactor: progress,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF8B5CF6), // Neon Mor
                                      Color(0xFF3B82F6), // Neon Mavi
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _todoItems.isEmpty 
                          ? 'Henüz bir görev eklemediniz.' 
                          : '${_todoItems.where((item) => item.isCompleted).length}/${_todoItems.length} görev tamamlandı',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Kategoriler Başlığı
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Kategoriler',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Kategori Kartları (Yatay Kaydırılabilir)
            SizedBox(
              height: 115,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 24, right: 12),
                scrollDirection: Axis.horizontal,
                itemCount: TodoCategory.values.length + 1, // +1 "Hepsi" filtresi için
                itemBuilder: (ctx, index) {
                  final isAllFilter = index == 0;
                  final category = isAllFilter ? null : TodoCategory.values[index - 1];
                  final isSelected = _activeFilter == category;
                  
                  final catColor = isAllFilter ? const Color(0xFF8B5CF6) : category!.color;
                  final catIcon = isAllFilter ? Icons.grid_view_rounded : category!.icon;
                  final catName = isAllFilter ? 'Hepsi' : category!.name;
                  final count = isAllFilter ? _todoItems.length : _getTaskCountForCategory(category!);

                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _activeFilter = category;
                        });
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 110,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? catColor.withOpacity(0.15) 
                              : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? catColor : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              catIcon,
                              color: catColor,
                              size: 24,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  catName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$count Görev',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Görevler Listesi Başlığı
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Görevler',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Görevler Listesi (Dikey)
            Expanded(
              child: filteredTodos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            size: 64,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Görev bulunamadı!',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Yeni bir tane eklemek için + tuşuna basın.',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: filteredTodos.length,
                      itemBuilder: (ctx, index) {
                        final todo = filteredTodos[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Dismissible(
                            key: Key(todo.id),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              _deleteTask(todo.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('"${todo.title}" silindi'),
                                  action: SnackBarAction(
                                    label: 'Geri Al',
                                    textColor: const Color(0xFF3B82F6),
                                    onPressed: () {
                                      setState(() {
                                        _todoItems.insert(index, todo);
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                              ),
                              child: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.redAccent,
                              ),
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: todo.isCompleted 
                                    ? const Color(0xFF1E293B).withOpacity(0.5) 
                                    : const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: todo.isCompleted
                                      ? Colors.transparent
                                      : Colors.white.withOpacity(0.03),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Özel Etkileşimli Checkbox
                                  GestureDetector(
                                    onTap: () => _toggleTaskStatus(todo.id),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      width: 26,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: todo.isCompleted
                                            ? todo.category.color
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: todo.isCompleted
                                              ? todo.category.color
                                              : Colors.grey[600]!,
                                          width: 2,
                                        ),
                                      ),
                                      child: todo.isCompleted
                                          ? const Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  
                                  // Görev Başlığı ve Kategori İkonu
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          todo.title,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: todo.isCompleted
                                                ? Colors.grey[500]
                                                : Colors.white,
                                            decoration: todo.isCompleted
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color: todo.category.color,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              todo.category.name,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey[500],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      
      // Floating Action Button (Premium Gradient)
      floatingActionButton: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF8B5CF6), // Neon Mor
              Color(0xFF3B82F6), // Neon Mavi
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B5CF6).withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _showAddTaskSheet(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
          child: const Icon(
            Icons.add_rounded,
            size: 32,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
