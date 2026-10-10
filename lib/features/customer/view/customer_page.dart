import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/page_header.dart';
import '../bloc/customer_cubit.dart';
import 'customer_detail_page.dart';

class CustomerPage extends StatelessWidget {
  const CustomerPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: BlocBuilder<CustomerCubit, CustomerState>(
        builder: (context, s) => Column(
          children: [
            const SizedBox(height: 66),
            const PageHeader(title: 'Customer'),
            const SizedBox(height: 50),
            // Panel bubble: pencarian + filter + list gabung.
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(
                    16, 16, 16, 24),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText:
                            'Cari nama / ID customer...',
                        prefixIcon: const Icon(
                            Icons.search,
                            color:
                                AppColors.primary),
                        filled: true,
                        fillColor:
                            AppColors.background,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    100),
                            borderSide:
                                const BorderSide(
                                    color: AppColors
                                        .border)),
                      ),
                      onChanged: (q) => context
                          .read<CustomerCubit>()
                          .search(q),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection:
                          Axis.horizontal,
                      child: Row(
                        children: [
                          'Semua',
                          'Aktif',
                          'Isolir'
                        ]
                            .map((f) => Padding(
                                  padding:
                                      const EdgeInsets
                                          .only(
                                              right:
                                                  8),
                                  child: ChoiceChip(
                                    label: Text(f),
                                    selected:
                                        s.filter ==
                                            f,
                                    selectedColor:
                                        AppColors
                                            .primaryDark,
                                    backgroundColor:
                                        AppColors
                                            .background,
                                    checkmarkColor:
                                        Colors.white,
                                    labelStyle:
                                        TextStyle(
                                      color: s.filter ==
                                              f
                                          ? Colors.white
                                          : AppColors
                                              .primaryDark,
                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                                    shape:
                                        const StadiumBorder(
                                            side: BorderSide(
                                                color: AppColors
                                                    .border)),
                                    onSelected: (_) =>
                                        context
                                            .read<
                                                CustomerCubit>()
                                            .setFilter(
                                                f),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: s.filtered.isEmpty
                          ? const Center(
                              child: Text(
                                  'Tidak ada customer',
                                  style:
                                      AppStyles.caption),
                            )
                          : ListView.builder(
                        itemCount: s.filtered.length,
                        itemBuilder: (_, i) {
                          final c = s.filtered[i];
                          final aktif =
                              c.status == 'Aktif';
                          return Container(
                            margin:
                                const EdgeInsets.only(
                                    bottom: 10),
                            decoration:
                                AppStyles.card,
                            child: ListTile(
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        24),
                              ),
                              onTap: () =>
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              CustomerDetailPage(
                                                  customer:
                                                      c))),
                              leading: CircleAvatar(
                                  backgroundColor:
                                      AppColors.primary,
                                  child: Text(c.nama[0],
                                      style: const TextStyle(
                                          color: Colors
                                              .white,
                                          fontWeight:
                                              FontWeight
                                                  .w700))),
                              title: Text(c.nama,
                                  style: const TextStyle(
                                      fontWeight:
                                          FontWeight.w600,
                                      fontSize: 14)),
                              subtitle: Text(
                                  '${c.id} • ${c.paket}',
                                  style:
                                      AppStyles.caption),
                              trailing: Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                            horizontal:
                                                12,
                                            vertical:
                                                6),
                                decoration:
                                    BoxDecoration(
                                        color: aktif
                                            ? AppColors
                                                .successBg
                                            : AppColors
                                                .dangerBg,
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    100)),
                                child: Text(c.status,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight:
                                            FontWeight
                                                .w700,
                                        color: aktif
                                            ? AppColors
                                                .success
                                            : AppColors
                                                .danger)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
