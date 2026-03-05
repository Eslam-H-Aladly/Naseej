import React, { createContext, useContext, useState, useEffect } from 'react';

type Language = 'ar' | 'en';

interface LanguageContextType {
  lang: Language;
  dir: 'rtl' | 'ltr';
  toggleLanguage: () => void;
  t: (key: string) => string;
}

const translations: Record<string, Record<Language, string>> = {
  'dashboard': { ar: 'لوحة التحكم', en: 'Dashboard' },
  'products': { ar: 'المنتجات', en: 'Products' },
  'orders': { ar: 'الطلبات', en: 'Orders' },
  'wallet': { ar: 'المحفظة', en: 'Wallet' },
  'settings': { ar: 'الإعدادات', en: 'Settings' },
  'total_revenue': { ar: 'إجمالي الإيرادات', en: 'Total Revenue' },
  'total_orders': { ar: 'إجمالي الطلبات', en: 'Total Orders' },
  'pending_orders': { ar: 'طلبات معلقة', en: 'Pending Orders' },
  'total_products': { ar: 'إجمالي المنتجات', en: 'Total Products' },
  'recent_orders': { ar: 'أحدث الطلبات', en: 'Recent Orders' },
  'wallet_overview': { ar: 'نظرة عامة على المحفظة', en: 'Wallet Overview' },
  'total_balance': { ar: 'الرصيد الإجمالي', en: 'Total Balance' },
  'pending_balance': { ar: 'رصيد معلق', en: 'Pending Balance' },
  'withdrawable': { ar: 'قابل للسحب', en: 'Withdrawable' },
  'add_product': { ar: 'إضافة منتج', en: 'Add Product' },
  'product_name': { ar: 'اسم المنتج', en: 'Product Name' },
  'price': { ar: 'السعر', en: 'Price' },
  'stock': { ar: 'المخزون', en: 'Stock' },
  'status': { ar: 'الحالة', en: 'Status' },
  'actions': { ar: 'الإجراءات', en: 'Actions' },
  'active': { ar: 'نشط', en: 'Active' },
  'inactive': { ar: 'غير نشط', en: 'Inactive' },
  'low_stock': { ar: 'مخزون منخفض', en: 'Low Stock' },
  'egp': { ar: 'ج.م', en: 'EGP' },
  'vendor_portal': { ar: 'بوابة البائع', en: 'Vendor Portal' },
  'welcome_back': { ar: 'مرحباً بعودتك', en: 'Welcome back' },
  'fabric': { ar: 'القماش', en: 'Fabric' },
  'color': { ar: 'اللون', en: 'Color' },
  'size_cm': { ar: 'المقاس (سم)', en: 'Size (CM)' },
  'wholesale': { ar: 'جملة', en: 'Wholesale' },
  'retail': { ar: 'تجزئة', en: 'Retail' },
  'search_products': { ar: 'البحث عن منتجات...', en: 'Search products...' },
  'all_products': { ar: 'كل المنتجات', en: 'All Products' },
  'edit': { ar: 'تعديل', en: 'Edit' },
  'delete': { ar: 'حذف', en: 'Delete' },
  'save': { ar: 'حفظ', en: 'Save' },
  'cancel': { ar: 'إلغاء', en: 'Cancel' },
  'description': { ar: 'الوصف', en: 'Description' },
  'category': { ar: 'التصنيف', en: 'Category' },
  'variants': { ar: 'المتغيرات', en: 'Variants' },
  'add_variant': { ar: 'إضافة متغير', en: 'Add Variant' },
  'sale_type': { ar: 'نوع البيع', en: 'Sale Type' },
  'order_id': { ar: 'رقم الطلب', en: 'Order ID' },
  'customer': { ar: 'العميل', en: 'Customer' },
  'date': { ar: 'التاريخ', en: 'Date' },
  'amount': { ar: 'المبلغ', en: 'Amount' },
  'new': { ar: 'جديد', en: 'New' },
  'accepted': { ar: 'مقبول', en: 'Accepted' },
  'shipped': { ar: 'تم الشحن', en: 'Shipped' },
  'delivered': { ar: 'تم التوصيل', en: 'Delivered' },
  'cancelled': { ar: 'ملغي', en: 'Cancelled' },
};

const LanguageContext = createContext<LanguageContextType | undefined>(undefined);

export const LanguageProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [lang, setLang] = useState<Language>('ar');
  const dir = lang === 'ar' ? 'rtl' : 'ltr';

  useEffect(() => {
    document.documentElement.dir = dir;
    document.documentElement.lang = lang;
  }, [lang, dir]);

  const toggleLanguage = () => setLang(prev => prev === 'ar' ? 'en' : 'ar');

  const t = (key: string) => translations[key]?.[lang] || key;

  return (
    <LanguageContext.Provider value={{ lang, dir, toggleLanguage, t }}>
      {children}
    </LanguageContext.Provider>
  );
};

export const useLanguage = () => {
  const ctx = useContext(LanguageContext);
  if (!ctx) throw new Error('useLanguage must be inside LanguageProvider');
  return ctx;
};
