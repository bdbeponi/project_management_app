// import 'package:project_management/app/constants/text_font_style.dart';
// import 'package:project_management/feature/explore/presentation/view_model/quick_exam_vm.dart';
// import 'package:project_management/gen/colors.gen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';

// class SubjectSelector extends StatefulWidget {
//   final List<String> allSubjects;
//   const SubjectSelector({super.key, required this.allSubjects});

//   @override
//   State<SubjectSelector> createState() => _SubjectSelectorState();
// }

// class _SubjectSelectorState extends State<SubjectSelector> {
//   final TextEditingController _controller = TextEditingController();
//   final FocusNode _focusNode = FocusNode();
//   final LayerLink _layerLink = LayerLink();
//   OverlayEntry? _overlayEntry;

//   List<String> _filteredSubjects = [];
//   String _hintText = "Select Subject";

//   @override
//   void initState() {
//     super.initState();
//     _filteredSubjects = widget.allSubjects;

//     _controller.addListener(_onSearchChanged);

//     _focusNode.addListener(() {
//       setState(() {
//         _hintText = _focusNode.hasFocus ? "Typing..." : "Select Subject";
//       });
//       if (_focusNode.hasFocus) {
//         _filterSubjects();
//         _showOverlay();
//       } else {
//         _removeOverlay();
//       }
//     });
//   }

//   void _onSearchChanged() {
//     _filterSubjects();
//     if (_focusNode.hasFocus) _showOverlay();
//   }

//   void _filterSubjects() {
//     // final selectedSubjects =
//     //     context.read<QuickExamViewModel>().selectedSubjects;
//     // setState(() {
//     //   _filteredSubjects = widget.allSubjects
//     //       .where((s) => !selectedSubjects.contains(s))
//     //       .where(
//     //           (s) => s.toLowerCase().contains(_controller.text.toLowerCase()))
//     //       .toList();
//     // });
//   }

//   void _showOverlay() {
//     _removeOverlay();

//     if (_filteredSubjects.isEmpty) return;

//     final RenderBox renderBox = context.findRenderObject() as RenderBox;
//     final Size size = renderBox.size;

//     _overlayEntry = OverlayEntry(
//       builder: (context) => GestureDetector(
//         behavior: HitTestBehavior.translucent,
//         onTap: () => _focusNode.unfocus(),
//         child: Stack(
//           children: [
//             Positioned(
//               width: size.width,
//               child: CompositedTransformFollower(
//                 link: _layerLink,
//                 showWhenUnlinked: false,
//                 offset: Offset(0, size.height + 5),
//                 child: Material(
//                   elevation: 4,
//                   borderRadius: BorderRadius.circular(12.r),
//                   color: AppColors.cFFFFFF,
//                   child: ConstrainedBox(
//                     constraints: const BoxConstraints(maxHeight: 200),
//                     child: ListView.separated(
//                       separatorBuilder: (_, __) => const Divider(height: 1),
//                       padding: EdgeInsets.zero,
//                       shrinkWrap: true,
//                       itemCount: _filteredSubjects.length,
//                       itemBuilder: (context, index) {
//                         final subject = _filteredSubjects[index];
//                         final isSelected = context
//                             .watch<QuickExamViewModel>()
//                             .selectedSubjects
//                             .contains(subject);

//                         return InkWell(
//                           onTap: () {
//                             context
//                                 .read<QuickExamViewModel>()
//                                 .addSubject(subject);
//                             _controller.clear();
//                             _filterSubjects();
//                             _focusNode.unfocus();
//                             setState(() => _hintText = "Select Subject");
//                           },
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 12.w, vertical: 12.h),
//                             color: isSelected
//                                 ? Colors.blue.withOpacity(0.1)
//                                 : Colors.transparent,
//                             child: Text(
//                               subject,
//                               style: TextFontStyle
//                                   .headline18w400cB9B9B9styleLexend
//                                   .copyWith(
//                                 fontSize: 12.sp,
//                                 color: isSelected
//                                     ? Colors.blue
//                                     : AppColors.c1A1C1E,
//                                 fontWeight: isSelected
//                                     ? FontWeight.w600
//                                     : FontWeight.normal,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );

//     Overlay.of(context).insert(_overlayEntry!);
//   }

//   void _removeOverlay() {
//     if (_overlayEntry?.mounted ?? false) {
//       _overlayEntry?.remove();
//       _overlayEntry = null;
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _focusNode.dispose();
//     _removeOverlay();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final selectedSubjects =
//         context.watch<QuickExamViewModel>().selectedSubjects;

//     return CompositedTransformTarget(
//       link: _layerLink,
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           border: Border.all(color: AppColors.cEDF1F3),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Wrap(
//           spacing: 6,
//           runSpacing: 6,
//           children: [
//             ...selectedSubjects.map((subject) => Chip(
//                   surfaceTintColor: Colors.transparent,
//                   label: Text(subject),
//                   onDeleted: () {
//                     context.read<QuickExamViewModel>().removeSubject(subject);
//                     _filterSubjects();
//                   },
//                   backgroundColor: AppColors.c471EBA.withAlpha(25),
//                   side: BorderSide(color: Colors.transparent),
//                 )),
//             ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: double.infinity),
//               child: TextField(
//                 controller: _controller,
//                 focusNode: _focusNode,
//                 decoration: InputDecoration(
//                   contentPadding:
//                       EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
//                   hintText: _hintText,
//                   hintStyle:
//                       TextFontStyle.headline12w500c6C7278styleLexend.copyWith(
//                     fontSize: 14.sp,
//                     color: AppColors.c1A1C1E,
//                   ),
//                   border: InputBorder.none,
//                   isDense: true,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_management/app/constants/text_font_style.dart';

class SubjectSelector extends StatefulWidget {
  final List<String> allSubjects;
  final List<String>? initialSelectedSubjects;
  final ValueChanged<List<String>>? onSelectionChanged;

  const SubjectSelector({
    super.key,
    required this.allSubjects,
    this.initialSelectedSubjects,
    this.onSelectionChanged,
  });

  @override
  State<SubjectSelector> createState() => _SubjectSelectorState();
}

class _SubjectSelectorState extends State<SubjectSelector> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  List<String> _filteredSubjects = [];
  List<String> _selectedSubjects = [];
  String _hintText = "Select Subject";

  @override
  void initState() {
    super.initState();
    _filteredSubjects = widget.allSubjects;
    _selectedSubjects = List.from(widget.initialSelectedSubjects ?? []);

    _controller.addListener(_onSearchChanged);

    _focusNode.addListener(() {
      setState(() {
        _hintText = _focusNode.hasFocus ? "Typing..." : "Select Subject";
      });
      if (_focusNode.hasFocus) {
        _filterSubjects();
        _showOverlay();
      } else {
        _removeOverlay();
      }
    });
  }

  void _onSearchChanged() {
    _filterSubjects();
    if (_focusNode.hasFocus) _showOverlay();
  }

  void _filterSubjects() {
    setState(() {
      _filteredSubjects = widget.allSubjects
          .where((s) => !_selectedSubjects.contains(s))
          .where(
            (s) => s.toLowerCase().contains(_controller.text.toLowerCase()),
          )
          .toList();
    });
  }

  void _showOverlay() {
    _removeOverlay();
    if (_filteredSubjects.isEmpty) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _focusNode.unfocus(),
        child: Stack(
          children: [
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 5),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12.r),
                  color: Colors.white,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.separated(
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _filteredSubjects.length,
                      itemBuilder: (context, index) {
                        final subject = _filteredSubjects[index];
                        final isSelected = _selectedSubjects.contains(subject);

                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedSubjects.add(subject);
                              _controller.clear();
                              _filterSubjects();
                              _hintText = "Select Subject";
                            });
                            widget.onSelectionChanged?.call(_selectedSubjects);
                            _focusNode.unfocus();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 12.h,
                            ),
                            color: isSelected
                                ? Colors.blue.withOpacity(0.1)
                                : Colors.transparent,
                            child: Text(
                              subject,
                              style: TextFontStyle
                                  .headline18w400cB9B9B9styleLexend
                                  .copyWith(
                                    fontSize: 12.sp,
                                    color: isSelected
                                        ? Colors.blue
                                        : Colors.black87,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    if (_overlayEntry?.mounted ?? false) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black87),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            ..._selectedSubjects.map(
              (subject) => Chip(
                surfaceTintColor: Colors.transparent,
                label: Text(subject),
                onDeleted: () {
                  setState(() {
                    _selectedSubjects.remove(subject);
                    _filterSubjects();
                  });
                  widget.onSelectionChanged?.call(_selectedSubjects);
                },
                backgroundColor: Colors.black87.withAlpha(25),
                side: const BorderSide(color: Colors.transparent),
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: double.infinity),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 6.h,
                  ),
                  hintText: _hintText,
                  hintStyle: TextFontStyle.headline12w500c6C7278styleLexend
                      .copyWith(fontSize: 14.sp, color: Colors.black87),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///EXAMPLE OF USE
///
///
//SubjectSelector(
//   allSubjects: ['Math', 'English', 'Science', 'History'],
//   initialSelectedSubjects: ['Math'],
//   onSelectionChanged: (subjects) {
//     print('Selected: $subjects');
//   },
// ),
