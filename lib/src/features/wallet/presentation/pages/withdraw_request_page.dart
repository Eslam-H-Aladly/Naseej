import 'package:flutter/material.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/section_header.dart';

class WithdrawRequestPage extends StatelessWidget {
  const WithdrawRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('طلب سحب'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'طلب سحب رصيد',
                subtitle: 'أدخل المبلغ ووسيلة التحويل المناسبة لك.',
              ),
              const SizedBox(height: 16),
              const AppTextField(
                label: 'مبلغ السحب',
                hintText: 'أقل مبلغ للسحب 500 ج.م',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const AppTextField(
                label: 'طريقة السحب',
                hintText: 'تحويل بنكي / محفظة / أخرى',
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'تأكيد طلب السحب',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم إرسال طلب السحب (واجهة تجريبية)'),
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

