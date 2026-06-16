import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/blog_model.dart';

// Mock blog data provider
final blogsProvider = FutureProvider<List<BlogModel>>((ref) async {
  // Simulate API delay
  await Future.delayed(const Duration(milliseconds: 500));

  return [
    BlogModel(
      id: '1',
      title: 'বিসিএস পরীক্ষায় সফল হওয়ার ৭টি কার্যকর কৌশল',
      excerpt:
          'বিসিএস পরীক্ষা আমাদের দেশের সবচেয়ে প্রতিযোগিতামূলক পরীক্ষা। এই পরীক্ষায় সফল হতে হলে আপনাকে সঠিক কৌশল এবং নিবেদন প্রয়োজন...',
      content: 'সম্পূর্ণ বিষয়বস্তু এখানে আসবে',
      imageUrl:
          'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=800',
      author: 'রহিম আহমেদ',
      authorImageUrl: 'https://i.pravatar.cc/100?u=rahim',
      category: 'পরীক্ষা প্রস্তুতি',
      publishedDate: DateTime.now().subtract(const Duration(days: 5)),
      readingTimeMinutes: 8,
      tags: ['বিসিএস', 'পরীক্ষা', 'কৌশল'],
      viewCount: 2340,
    ),
    BlogModel(
      id: '2',
      title: 'ইংরেজি গ্রামার: Common Mistakes এবং কীভাবে সেগুলো এড়াবেন',
      excerpt:
          'ইংরেজি শেখার সময় আমরা অনেক সাধারণ ভুল করি। এই নিবন্ধে আমরা দেখব সবচেয়ে সাধারণ ভুলগুলি কী এবং কীভাবে সেগুলি এড়ানো যায়...',
      content: 'সম্পূর্ণ বিষয়বস্তু এখানে আসবে',
      imageUrl:
          'https://images.unsplash.com/photo-1507842217343-583b8a0b4d8b?w=800',
      author: 'ফাতেমা খান',
      authorImageUrl: 'https://i.pravatar.cc/100?u=fatema',
      category: 'ইংরেজি',
      publishedDate: DateTime.now().subtract(const Duration(days: 10)),
      readingTimeMinutes: 6,
      tags: ['ইংরেজি', 'গ্রামার', 'টিপস'],
      viewCount: 3100,
    ),
    BlogModel(
      id: '3',
      title: 'গণিত অধ্যায় ১: সংখ্যা ও সংখ্যা পদ্ধতি - সম্পূর্ণ গাইড',
      excerpt:
          'গণিতের মৌলিক ধারণাগুলি বোঝা অত্যন্ত গুরুত্বপূর্ণ। এই গাইডে আমরা সংখ্যা ব্যবস্থা, বিভিন্ন ধরনের সংখ্যা এবং তাদের প্রয়োগ সম্পর্কে শিখব...',
      content: 'সম্পূর্ণ বিষয়বস্তু এখানে আসবে',
      imageUrl:
          'https://images.unsplash.com/photo-1596495577886-d920f1fb7238?w=800',
      author: 'করিম হোসেন',
      authorImageUrl: 'https://i.pravatar.cc/100?u=karim',
      category: 'গণিত',
      publishedDate: DateTime.now().subtract(const Duration(days: 3)),
      readingTimeMinutes: 10,
      tags: ['গণিত', 'সংখ্যা', 'অধ্যায়'],
      viewCount: 1890,
    ),
    BlogModel(
      id: '4',
      title: 'প্রাথমিক শিক্ষক নিয়োগ পরীক্ষা ২০২৪ - সম্পূর্ণ প্রস্তুতি গাইড',
      excerpt:
          'প্রাথমিক শিক্ষক নিয়োগ পরীক্ষা খুবই গুরুত্বপূর্ণ এবং প্রতিযোগিতাপূর্ণ। এই গাইডে আমরা পরীক্ষার বিষয়বস্তু, পাঠ্যক্রম এবং প্রস্তুতির টিপস নিয়ে আলোচনা করব...',
      content: 'সম্পূর্ণ বিষয়বস্তু এখানে আসবে',
      imageUrl:
          'https://images.unsplash.com/photo-1552664730-d307ca884978?w=800',
      author: 'নাজমা বেগম',
      authorImageUrl: 'https://i.pravatar.cc/100?u=nazma',
      category: 'শিক্ষক নিয়োগ',
      publishedDate: DateTime.now().subtract(const Duration(days: 7)),
      readingTimeMinutes: 12,
      tags: ['শিক্ষক নিয়োগ', 'পরীক্ষা', '২০২৪'],
      viewCount: 4520,
    ),
    BlogModel(
      id: '5',
      title: 'ব্যাংক পরীক্ষায় সফল হওয়ার জন্য রিজনিং প্রস্তুতি',
      excerpt:
          'ব্যাংক পরীক্ষায় রিজনিং একটি গুরুত্বপূর্ণ বিভাগ। এখানে আমরা বিভিন্ন ধরনের রিজনিং প্রশ্ন এবং সেগুলি দ্রুত সমাধানের কৌশল শিখব...',
      content: 'সম্পূর্ণ বিষয়বস্তু এখানে আসবে',
      imageUrl:
          'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=800',
      author: 'সাবেরা আক্তার',
      authorImageUrl: 'https://i.pravatar.cc/100?u=sabera',
      category: 'ব্যাংক পরীক্ষা',
      publishedDate: DateTime.now().subtract(const Duration(days: 12)),
      readingTimeMinutes: 9,
      tags: ['ব্যাংক', 'রিজনিং', 'প্রস্তুতি'],
      viewCount: 2670,
    ),
    BlogModel(
      id: '6',
      title: 'অনলাইনে পড়াশোনা করার সুবিধা এবং চ্যালেঞ্জ',
      excerpt:
          'আধুনিক যুগে অনলাইন শিক্ষা অত্যন্ত জনপ্রিয় হয়ে উঠেছে। এই নিবন্ধে আমরা অনলাইন শেখার সুবিধা, চ্যালেঞ্জ এবং কীভাবে সফলভাবে অনলাইনে শিখতে হয় তা নিয়ে আলোচনা করব...',
      content: 'সম্পূর্ণ বিষয়বস্তু এখানে আসবে',
      imageUrl:
          'https://images.unsplash.com/photo-1516321318423-f06f70ab7cb0?w=800',
      author: 'আবদুল করিম',
      authorImageUrl: 'https://i.pravatar.cc/100?u=abdul',
      category: 'শিক্ষা পদ্ধতি',
      publishedDate: DateTime.now().subtract(const Duration(days: 15)),
      readingTimeMinutes: 7,
      tags: ['অনলাইন শিক্ষা', 'ডিজিটাল', 'টিপস'],
      viewCount: 3450,
    ),
  ];
});
