import React, { useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { useLanguage } from '@/contexts/LanguageContext';
import {
  LayoutDashboard,
  Package,
  ShoppingCart,
  Wallet,
  Settings,
  Menu,
  X,
  Globe,
  LogOut,
  ChevronLeft,
  ChevronRight,
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { cn } from '@/lib/utils';

const DashboardLayout: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const { t, lang, dir, toggleLanguage } = useLanguage();
  const location = useLocation();
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [collapsed, setCollapsed] = useState(false);

  const navItems = [
    { path: '/', icon: LayoutDashboard, label: 'dashboard' },
    { path: '/products', icon: Package, label: 'products' },
    { path: '/orders', icon: ShoppingCart, label: 'orders' },
    { path: '/wallet', icon: Wallet, label: 'wallet' },
    { path: '/settings', icon: Settings, label: 'settings' },
  ];

  const CollapseIcon = dir === 'rtl' ? ChevronRight : ChevronLeft;
  const ExpandIcon = dir === 'rtl' ? ChevronLeft : ChevronRight;

  return (
    <div className="flex h-screen overflow-hidden" dir={dir}>
      {/* Mobile overlay */}
      {sidebarOpen && (
        <div
          className="fixed inset-0 z-40 bg-foreground/20 backdrop-blur-sm lg:hidden"
          onClick={() => setSidebarOpen(false)}
        />
      )}

      {/* Sidebar */}
      <aside
        className={cn(
          'fixed inset-y-0 z-50 flex flex-col bg-sidebar text-sidebar-foreground transition-all duration-300 lg:relative',
          dir === 'rtl' ? 'right-0' : 'left-0',
          collapsed ? 'w-[72px]' : 'w-64',
          sidebarOpen ? 'translate-x-0' : dir === 'rtl' ? 'translate-x-full lg:translate-x-0' : '-translate-x-full lg:translate-x-0'
        )}
      >
        {/* Logo */}
        <div className="flex h-16 items-center justify-between px-4 border-b border-sidebar-border">
          {!collapsed && (
            <h1 className="text-lg font-bold text-sidebar-primary-foreground tracking-wide">
              {t('vendor_portal')}
            </h1>
          )}
          <Button
            variant="ghost"
            size="icon"
            className="hidden lg:flex text-sidebar-foreground hover:bg-sidebar-accent"
            onClick={() => setCollapsed(!collapsed)}
          >
            {collapsed ? <ExpandIcon className="h-4 w-4" /> : <CollapseIcon className="h-4 w-4" />}
          </Button>
          <Button
            variant="ghost"
            size="icon"
            className="lg:hidden text-sidebar-foreground"
            onClick={() => setSidebarOpen(false)}
          >
            <X className="h-5 w-5" />
          </Button>
        </div>

        {/* Nav */}
        <nav className="flex-1 py-4 space-y-1 px-3">
          {navItems.map((item) => {
            const isActive = location.pathname === item.path;
            return (
              <Link
                key={item.path}
                to={item.path}
                onClick={() => setSidebarOpen(false)}
                className={cn(
                  'flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium transition-all duration-200',
                  isActive
                    ? 'bg-sidebar-primary text-sidebar-primary-foreground shadow-md'
                    : 'text-sidebar-foreground hover:bg-sidebar-accent hover:text-sidebar-accent-foreground'
                )}
              >
                <item.icon className="h-5 w-5 shrink-0" />
                {!collapsed && <span>{t(item.label)}</span>}
              </Link>
            );
          })}
        </nav>

        {/* Bottom */}
        <div className="border-t border-sidebar-border p-3 space-y-1">
          <Button
            variant="ghost"
            className="w-full justify-start gap-3 text-sidebar-foreground hover:bg-sidebar-accent"
            onClick={toggleLanguage}
          >
            <Globe className="h-5 w-5 shrink-0" />
            {!collapsed && <span>{lang === 'ar' ? 'English' : 'عربي'}</span>}
          </Button>
          <Button
            variant="ghost"
            className="w-full justify-start gap-3 text-sidebar-foreground hover:bg-sidebar-accent"
          >
            <LogOut className="h-5 w-5 shrink-0" />
            {!collapsed && <span>{lang === 'ar' ? 'تسجيل خروج' : 'Logout'}</span>}
          </Button>
        </div>
      </aside>

      {/* Main */}
      <main className="flex-1 flex flex-col overflow-hidden">
        {/* Top bar */}
        <header className="h-16 border-b border-border bg-background flex items-center justify-between px-4 lg:px-8 shrink-0">
          <Button
            variant="ghost"
            size="icon"
            className="lg:hidden"
            onClick={() => setSidebarOpen(true)}
          >
            <Menu className="h-5 w-5" />
          </Button>
          <div className="hidden lg:block">
            <p className="text-sm text-muted-foreground">{t('welcome_back')}</p>
          </div>
          <div className="flex items-center gap-2">
            <div className="h-9 w-9 rounded-full bg-primary/10 flex items-center justify-center">
              <span className="text-sm font-semibold text-primary">م</span>
            </div>
          </div>
        </header>

        {/* Content */}
        <div className="flex-1 overflow-y-auto p-4 lg:p-8">
          {children}
        </div>
      </main>
    </div>
  );
};

export default DashboardLayout;
