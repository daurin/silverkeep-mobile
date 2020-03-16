import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:silverkeep/db/models/Transaction.dart';
import 'package:silverkeep/modules/shared/colors/ColorsApp.dart';

class TransactionItem extends StatelessWidget {
  final double amount;
  final Transaction transaction;

  const TransactionItem({Key key, this.transaction, this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        //height: transaction.labels.length==0?72:null,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildTitle(context),
                    SizedBox(height: 5,),
                    _buildSubtitle(context),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    _buildAmount(context),
                    SizedBox(height: 2,),
                    _buildStatus(context),
                  ],
                ),
              ],
            ),
            Visibility(
              visible: transaction.labels.length>0,
              child: SizedBox(
                height: 5
              )
            ),
            Visibility(
              visible: transaction.labels.length>0,
              child: _buildLabels(context)
            )
          ],
        ),
      ),
      onTap: _onTab,
    );
  }

  Widget _buildTitle(BuildContext context){
    return Text(
      transaction.description ?? '',
      style: Theme.of(context).textTheme.subhead,
    );
  }

  _buildSubtitle(BuildContext context) {
    if (transaction.transactionType != TransactionType.Transfer)return Text(
      transaction.account.name,
      style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 14),
    );
    else return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 14),
        children: [
          TextSpan(
            text: transaction.account.name + ' ',
          ),
          WidgetSpan(
            child: Icon(
              MdiIcons.swapHorizontal,
              size: 12,
            ),
            alignment: PlaceholderAlignment.middle,
          ),
          TextSpan(
            text: ' ${transaction?.accountTransfer?.name}',
          ),
        ]
      )
    );
  }

  Widget _buildLabels(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 5,
      runSpacing: 5,
      children: (transaction.labels ?? []).map((item) {
        return Container(
          //margin: EdgeInsets.only(left: 5),
          child: Text(
            item.name,
            style: Theme.of(context).textTheme.caption.copyWith(
              fontSize: 13,
              //color: ColorsApp(context).getColorByKey(item.color)
            ),
          ),
          padding: EdgeInsets.fromLTRB(7, 3, 7, 2),
          decoration: BoxDecoration(
              color: ColorsApp(context).getColorByKey(item.color) != null?
                ColorsApp(context).getColorByKey(item.color).withOpacity(0.3):
                null,
              border:
                  Border.all(width: 1, color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.all(Radius.circular(7))),
        );
      }).toList(),
    );
  }

  Widget _buildAmount(BuildContext context){
    return RichText(
    text: TextSpan(children: [
      () {
        TextStyle textStyle =
            Theme.of(context).textTheme.title.copyWith(fontSize: 18);
        switch (transaction.transactionType) {
          case TransactionType.Income:
            textStyle = textStyle.copyWith(color: Colors.green);
            return TextSpan(
                text: '+ \$${NumberFormat().format(transaction.amount)}',
                style: textStyle);
          case TransactionType.Expense:
            textStyle = textStyle.copyWith(color: Colors.red);
            return TextSpan(
                text: '- \$${NumberFormat().format(transaction.amount)}',
                style: textStyle);
          case TransactionType.Transfer:
            //textStyle=textStyle.copyWith(color: Colors.green);
            return TextSpan(
                text: '\$${NumberFormat().format(transaction.amount)}',
                style: textStyle);
          default:
            return TextSpan();
        }
      }(),
    ]));
  }
  
  

  _buildStatus(BuildContext context) {
    return Visibility(
      visible: true,
      child: RichText(
        text: TextSpan(children: [
          WidgetSpan(
            child: Icon(
                true? Icons.check : Icons.refresh,
                size: 14,
                color: Colors.grey,
              ),
              alignment: PlaceholderAlignment.middle,
              style: Theme.of(context).textTheme.subtitle
            ),
            TextSpan(
              text: true?' Realizada':' Pendiente',
              style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 13)
            ),
            // TextSpan(
            //   text: " - ${DateFormat.Hm().format(transaction.date)}",
            //   style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 13)
            // )
          ]
        )
      ),
    );
  }

  void _onTab() {}

}
