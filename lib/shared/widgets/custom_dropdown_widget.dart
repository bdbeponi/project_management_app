import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_management/app/constants/text_font_style.dart';

class CustomDropdown<T> extends StatefulWidget {
  final String? hintText;
  final List<T> items;
  final T? value;
  final String Function(T) itemLabel;
  final void Function(T?) onChanged;
  final double borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;
  final double menuMaxHeight;
  final double elevation;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.value,
    this.hintText,
    this.borderRadius = 8.0,
    this.borderColor,
    this.backgroundColor,
    this.menuMaxHeight = 250,
    this.elevation = 4,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggleDropdown() {
    if (_isOpen) {
      _removeDropdown();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() {
    final overlay = Overlay.of(context);
    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _removeDropdown() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;

      if (mounted) {
        setState(() => _isOpen = false);
      } else {
        _isOpen = false;
      }
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => GestureDetector(
        // Close dropdown when tapping outside
        onTap: _removeDropdown,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 4,
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 4),
                child: Material(
                  elevation: widget.elevation,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  color: widget.backgroundColor ?? Colors.white,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: widget.menuMaxHeight,
                    ),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: widget.items.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        final isSelected = item == widget.value;
                        return InkWell(
                          onTap: () {
                            widget.onChanged(item);
                            _removeDropdown();
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
                              widget.itemLabel(item),
                              // style: TextStyle(
                              //   fontSize: 14.sp,
                              //   color:
                              //       isSelected ? Colors.blue : Colors.black87,
                              //   fontWeight: isSelected
                              //       ? FontWeight.w600
                              //       : FontWeight.normal,
                              // ),
                              style: TextFontStyle
                                  .headline18w400cB9B9B9styleLexend
                                  .copyWith(
                                    fontSize: 12.sp,
                                    color: isSelected
                                        ? Colors.black
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
  }

  @override
  void dispose() {
    // Safely remove overlay without calling setState
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: widget.borderColor ?? Colors.grey.shade300,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.value != null
                      ? widget.itemLabel(widget.value as T)
                      : widget.hintText ?? "Select an option",
                  // style: TextStyle(
                  //   fontSize: 14.sp,
                  //   color: widget.value != null ? Colors.black : Colors.grey,
                  // ),
                  style: TextFontStyle.headline12w500c6C7278styleLexend
                      .copyWith(fontSize: 14.sp, color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                // color: Colors.grey,
                color: Colors.black87,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
