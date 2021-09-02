import 'package:flutter/material.dart';

class TextFieldDropdown extends StatefulWidget {
  final String hint;
  final List<String> options;
  final TextEditingController controller;

  const TextFieldDropdown({
    Key? key,
    required this.options,
    required this.hint,
    required this.controller,
  }) : super(key: key);

  @override
  _TextFieldDropdownState createState() => _TextFieldDropdownState();
}

//****dropdown */
class _TextFieldDropdownState extends State<TextFieldDropdown> {
  OverlayEntry? _entry;

  TextEditingController get controller => widget.controller;

  final overlayVerticalGap = 4.0;

  OverlayEntry _createOverlayEntry() {
    var renderBox = context.findRenderObject()! as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    final currentOption = controller.text.toLowerCase();
    final optionsItems = widget.options.map(
      (option) {
        final _selected = currentOption == option.toLowerCase();
        final icon = _selected
            ? const Icon(
                Icons.arrow_right,
                size: 14,
              )
            : const SizedBox.shrink();
        final _style = _selected
            ? kInputDropdownItemStyle.copyWith(fontWeight: FontWeight.w700)
            : kInputDropdownItemStyle;
        return ListTile(
          title: Text(
            option,
            style: _style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          selected: _selected,
          selectedTileColor: kDarkBlueColor.withOpacity(.08),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          leading: icon,
          minLeadingWidth: 8,
          horizontalTitleGap: 8,
          dense: true,
          onTap: () => _onOptionTap(option),
        );
      },
    ).toList();
    return OverlayEntry(
      opaque: false,
      builder: (context) {
        return Positioned(
          left: offset.dx,
          top: offset.dy + size.height + overlayVerticalGap,
          width: size.width,
          child: CompositedTransformFollower(
            link: _overlayLink,
            offset: Offset(0, size.height + overlayVerticalGap),
            showWhenUnlinked: false,
            child: SizedBox(
              height: 300,
              child: Material(
                elevation: 2.0,
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: optionsItems,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool get _isOverlayOpened => _entry != null;

  void _toggleOverlay(bool show) {
    if (show == _isOverlayOpened) return;
    if (show) {
      _entry = _createOverlayEntry();
      Overlay.of(context)!.insert(_entry!);
    } else {
      _entry?.remove();
      _entry = null;
    }
    setState(() {});
  }

  void _onOptionTap(String option) {
    controller.text = option;
    controller.selection = TextSelection.collapsed(offset: option.length);
    _toggleOverlay(false);
  }

  final _overlayLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      onFocusChange: _toggleOverlay,
      child: CompositedTransformTarget(
        link: _overlayLink,
        child: SuffixedTextField(
          hint: widget.hint,
          onTap: () {
            if (!_isOverlayOpened) {
              _toggleOverlay(true);
            }
          },
          controller: controller,
          suffix: _SuffixButton(
            color: Colors.transparent,
            child: RotatedBox(
              quarterTurns: _isOverlayOpened ? 3 : 1,
              child: const Icon(
                Icons.chevron_right,
                size: 18,
                color: kInputTextColor,
              ),
            ),
            onTap: () {
              if (_isOverlayOpened) {
                WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                  _toggleOverlay(false);
                });
              }
            },
          ),
        ),
      ),
    );
  }
}

class TextFieldCalendar extends StatefulWidget {
  final String hint;
  final TextEditingController controller;

  const TextFieldCalendar({
    Key? key,
    required this.controller,
    required this.hint,
  }) : super(key: key);

  @override
  _TextFieldCalendarState createState() => _TextFieldCalendarState();
}

class _TextFieldCalendarState extends State<TextFieldCalendar> {
  TextEditingController get controller => widget.controller;
  DateTime currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SuffixedTextField(
      hint: widget.hint,
      controller: widget.controller,
      onTap: openCalendar,
      suffix: _SuffixButton(
        color: kInputTextColor,
        child: const Icon(
          Icons.calendar_today_outlined,
          size: 18,
          color: Colors.white,
        ),
        onTap: () {},
        // onTap: openCalendar,
      ),
    );
  }

  void openCalendar() async {
    var date = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1990),
      lastDate: DateTime(2024),
    );
    if (date != null) {
      currentDate = date;
      final _month = engMonths[date.month - 1];
      final dateStr = '${date.day} $_month ${date.year}';
      controller.text = dateStr;
    }
  }
}

// ********** Wrapper for common TextField style.
class SuffixedTextField extends StatelessWidget {
  final String hint;
  final Widget? suffix;
  final TextEditingController controller;
  final VoidCallback? onTap;

  const SuffixedTextField({
    Key? key,
    this.onTap,
    this.suffix,
    required this.hint,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: TextField(
        style: kInputTextStyle,
        controller: controller,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: kInputHintStyle,
          isDense: true,
          contentPadding: const EdgeInsets.only(left: 8, right: 8),
          suffixIcon: suffix,
          border: kInputBorder,
          enabledBorder: kInputBorder,
          focusedBorder: kInputBorderFocus,
        ),
      ),
    );
  }
}

class _SuffixButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color color;
  final Widget child;

  const _SuffixButton({
    Key? key,
    this.onTap,
    required this.child,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      color: color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(4),
        ),
      ),
      elevation: 0,
      hoverElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      child: child,
      minWidth: 40,
    );
  }
}

/// ************ wrapper for the title.
class InputTitle extends StatelessWidget {
  final Widget child;
  final String title;

  const InputTitle({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: kInputTitleStyle,
        ),
        const SizedBox(height: 15),
        child,
      ],
    );
  }
}

/// ****** Colors *****

const kDarkBlueColor = Color(0xff424F6A);
const kLightGreyColor = Color(0xffC5C4C4);
const kInputTextColor = Color(0xff354360);

/// ******** Text Styles *********
final kInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(4),
  borderSide: const BorderSide(color: kLightGreyColor),
);

final kInputBorderFocus = kInputBorder.copyWith(
  borderSide: const BorderSide(color: kDarkBlueColor, width: 2),
);

const kInputTitleStyle = TextStyle(
  color: kDarkBlueColor,
  fontWeight: FontWeight.w600,
  fontSize: 12,
);

const kInputTextStyle = TextStyle(
  color: kInputTextColor,
  fontSize: 11,
  fontWeight: FontWeight.w500,
);

const kInputHintStyle = TextStyle(
  color: kLightGreyColor,
  fontSize: 11,
  fontWeight: FontWeight.w400,
);

const kInputDropdownItemStyle = TextStyle(
  color: kDarkBlueColor,
  fontSize: 11,
  fontWeight: FontWeight.w500,
);

// ******** Months**********

const engMonths = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];
