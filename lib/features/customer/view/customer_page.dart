import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../bloc/customer_cubit.dart';
import 'customer_detail_page.dart';

class CustomerPage extends StatelessWidget {
  const CustomerPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerCubit, CustomerState>(
      builder: (context, s) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari nama / ID customer...',
                prefixIcon: const Icon(Icons.search,
                    color: AppColors.primary),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide:
                        const BorderSide(color: AppColors.border)),
              ),
              onChanged: (q) =>
                  context.read<CustomerCubit>().search(q),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              itemCount: s.filtered.length,
              itemBuilder: (_, i) {
                final c = s.filtered[i];
                final aktif = c.status == 'Aktif';
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: AppStyles.card,
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(24),
                    ),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                CustomerDetailPage(
                                    customer: c))),
                    leading: CircleAvatar(
                        backgroundColor:
                            AppColors.primary,
                        child: Text(c.nama[0],
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.w700))),
                    title: Text(c.nama,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                    subtitle: Text(
                        '${c.id} • ${c.paket}',
                        style: AppStyles.caption),
                    trailing: Container(
                      padding:
                          const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6),
                      decoration: BoxDecoration(
                          color: aktif
                              ? AppColors.successBg
                              : AppColors.dangerBg,
                          borderRadius:
                              BorderRadius.circular(100)),
                      child: Text(c.status,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: aktif
                                  ? AppColors.success
                                  : AppColors.danger)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
