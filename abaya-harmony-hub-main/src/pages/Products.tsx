import { useState } from 'react';
import { useLanguage } from '@/contexts/LanguageContext';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { Plus, Search, Edit, Trash2, AlertTriangle, Package } from 'lucide-react';
import { cn } from '@/lib/utils';

interface Variant {
  fabric: string;
  color: string;
  sizeCm: string;
  stock: number;
}

interface Product {
  id: string;
  name: string;
  nameEn: string;
  description: string;
  price: number;
  saleType: 'retail' | 'wholesale';
  variants: Variant[];
  status: 'active' | 'inactive';
  image?: string;
}

const mockProducts: Product[] = [
  {
    id: '1',
    name: 'عباية الملكة السوداء',
    nameEn: 'Black Queen Abaya',
    description: 'عباية فاخرة من الكريب الثقيل',
    price: 850,
    saleType: 'retail',
    variants: [
      { fabric: 'كريب', color: 'أسود', sizeCm: '52', stock: 15 },
      { fabric: 'كريب', color: 'أسود', sizeCm: '54', stock: 8 },
      { fabric: 'كريب', color: 'أسود', sizeCm: '56', stock: 1 },
    ],
    status: 'active',
  },
  {
    id: '2',
    name: 'عباية النسيم',
    nameEn: 'Naseem Abaya',
    description: 'عباية خفيفة من الشيفون',
    price: 620,
    saleType: 'retail',
    variants: [
      { fabric: 'شيفون', color: 'كحلي', sizeCm: '52', stock: 20 },
      { fabric: 'شيفون', color: 'كحلي', sizeCm: '54', stock: 12 },
    ],
    status: 'active',
  },
  {
    id: '3',
    name: 'عباية الجوهرة',
    nameEn: 'Jawharah Abaya',
    description: 'عباية مطرزة يدوياً بالكريستال',
    price: 2100,
    saleType: 'wholesale',
    variants: [
      { fabric: 'ندا', color: 'أسود', sizeCm: '52', stock: 50 },
      { fabric: 'ندا', color: 'بيج', sizeCm: '54', stock: 0 },
    ],
    status: 'active',
  },
  {
    id: '4',
    name: 'عباية الوردة',
    nameEn: 'Rose Abaya',
    description: 'عباية يومية بسيطة وأنيقة',
    price: 430,
    saleType: 'retail',
    variants: [
      { fabric: 'لينن', color: 'رمادي', sizeCm: '56', stock: 3 },
    ],
    status: 'inactive',
  },
];

const Products = () => {
  const { t, lang } = useLanguage();
  const [search, setSearch] = useState('');
  const [dialogOpen, setDialogOpen] = useState(false);

  const filteredProducts = mockProducts.filter((p) =>
    p.name.includes(search) || p.nameEn.toLowerCase().includes(search.toLowerCase())
  );

  const totalStock = (variants: Variant[]) => variants.reduce((sum, v) => sum + v.stock, 0);
  const hasLowStock = (variants: Variant[]) => variants.some((v) => v.stock <= 1 && v.stock > 0);

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold">{t('products')}</h1>
          <p className="text-sm text-muted-foreground mt-1">
            {filteredProducts.length} {t('total_products').toLowerCase()}
          </p>
        </div>
        <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
          <DialogTrigger asChild>
            <Button className="gap-2">
              <Plus className="h-4 w-4" />
              {t('add_product')}
            </Button>
          </DialogTrigger>
          <DialogContent className="max-w-lg max-h-[85vh] overflow-y-auto">
            <DialogHeader>
              <DialogTitle>{t('add_product')}</DialogTitle>
            </DialogHeader>
            <div className="space-y-4 pt-2">
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label>{t('product_name')} (عربي)</Label>
                  <Input placeholder="عباية..." />
                </div>
                <div className="space-y-2">
                  <Label>{t('product_name')} (English)</Label>
                  <Input placeholder="Abaya..." />
                </div>
              </div>
              <div className="space-y-2">
                <Label>{t('description')}</Label>
                <Textarea placeholder="..." rows={3} />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label>{t('price')} ({t('egp')})</Label>
                  <Input type="number" placeholder="0" />
                </div>
                <div className="space-y-2">
                  <Label>{t('sale_type')}</Label>
                  <Select>
                    <SelectTrigger>
                      <SelectValue placeholder={t('retail')} />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="retail">{t('retail')}</SelectItem>
                      <SelectItem value="wholesale">{t('wholesale')}</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>

              {/* Variant Section */}
              <div className="space-y-3">
                <div className="flex items-center justify-between">
                  <Label className="text-base font-semibold">{t('variants')}</Label>
                  <Button variant="outline" size="sm" className="gap-1.5">
                    <Plus className="h-3.5 w-3.5" />
                    {t('add_variant')}
                  </Button>
                </div>
                <div className="rounded-xl border border-border p-4 space-y-3 bg-muted/30">
                  <div className="grid grid-cols-4 gap-3">
                    <div className="space-y-1">
                      <Label className="text-xs">{t('fabric')}</Label>
                      <Input placeholder="كريب" className="h-9 text-sm" />
                    </div>
                    <div className="space-y-1">
                      <Label className="text-xs">{t('color')}</Label>
                      <Input placeholder="أسود" className="h-9 text-sm" />
                    </div>
                    <div className="space-y-1">
                      <Label className="text-xs">{t('size_cm')}</Label>
                      <Input placeholder="52" className="h-9 text-sm" />
                    </div>
                    <div className="space-y-1">
                      <Label className="text-xs">{t('stock')}</Label>
                      <Input type="number" placeholder="0" className="h-9 text-sm" />
                    </div>
                  </div>
                </div>
              </div>

              <div className="flex gap-3 pt-2">
                <Button className="flex-1">{t('save')}</Button>
                <Button variant="outline" onClick={() => setDialogOpen(false)}>{t('cancel')}</Button>
              </div>
            </div>
          </DialogContent>
        </Dialog>
      </div>

      {/* Search */}
      <div className="relative max-w-sm">
        <Search className="absolute start-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
        <Input
          placeholder={t('search_products')}
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="ps-9"
        />
      </div>

      {/* Product Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
        {filteredProducts.map((product) => (
          <Card key={product.id} className="border-0 shadow-sm hover:shadow-md transition-all duration-300 group">
            <CardContent className="p-5">
              {/* Product image placeholder */}
              <div className="aspect-[4/3] rounded-xl bg-gradient-to-br from-muted to-accent/40 mb-4 flex items-center justify-center overflow-hidden">
                <Package className="h-12 w-12 text-muted-foreground/30" />
              </div>

              <div className="space-y-3">
                <div className="flex items-start justify-between">
                  <div>
                    <h3 className="font-bold text-base">{product.name}</h3>
                    <p className="text-xs text-muted-foreground mt-0.5">{product.nameEn}</p>
                  </div>
                  <Badge
                    variant="outline"
                    className={cn(
                      'text-xs',
                      product.saleType === 'wholesale'
                        ? 'bg-primary/10 text-primary border-primary/20'
                        : 'bg-accent text-accent-foreground border-accent'
                    )}
                  >
                    {t(product.saleType)}
                  </Badge>
                </div>

                <p className="text-xs text-muted-foreground line-clamp-1">{product.description}</p>

                <div className="flex items-center justify-between">
                  <span className="text-lg font-bold text-primary">
                    {product.price} <span className="text-xs font-normal text-muted-foreground">{t('egp')}</span>
                  </span>
                  <div className="flex items-center gap-1.5">
                    {hasLowStock(product.variants) && (
                      <span className="flex items-center gap-1 text-xs text-warning">
                        <AlertTriangle className="h-3.5 w-3.5" />
                        {t('low_stock')}
                      </span>
                    )}
                    <Badge variant={product.status === 'active' ? 'default' : 'secondary'} className="text-xs">
                      {t(product.status)}
                    </Badge>
                  </div>
                </div>

                {/* Variants preview */}
                <div className="flex flex-wrap gap-1.5">
                  {product.variants.map((v, i) => (
                    <span
                      key={i}
                      className={cn(
                        'text-xs px-2 py-0.5 rounded-md border',
                        v.stock <= 1 && v.stock > 0
                          ? 'border-warning/30 bg-warning/8 text-warning'
                          : v.stock === 0
                          ? 'border-destructive/30 bg-destructive/8 text-destructive line-through'
                          : 'border-border bg-muted/50 text-muted-foreground'
                      )}
                    >
                      {v.sizeCm}cm · {v.color} ({v.stock})
                    </span>
                  ))}
                </div>

                {/* Actions */}
                <div className="flex gap-2 pt-1 opacity-0 group-hover:opacity-100 transition-opacity">
                  <Button variant="outline" size="sm" className="flex-1 gap-1.5">
                    <Edit className="h-3.5 w-3.5" />
                    {t('edit')}
                  </Button>
                  <Button variant="outline" size="sm" className="text-destructive hover:text-destructive">
                    <Trash2 className="h-3.5 w-3.5" />
                  </Button>
                </div>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  );
};

export default Products;
