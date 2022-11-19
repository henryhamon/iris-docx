Class dc.docx.sample.Donuts Extends %Persistent
{

Property Name As %String;

Property Desc As %String(MAXLEN = 150);

Property Img As %String;

ClassMethod AddRecord(Output id As %Integer, name As %String, desc As %String, img As %String = "") As %Status
{
    Set sc=$$$OK
    Set obj=..%New()
    Set obj.Name = name
    Set obj.Desc= desc
    Set obj.Img = img
    Try {
      TStart
      $$$ThrowOnError(obj.%Save())
      TCommit
    } Catch tErr {
      TRollback
      W !,"Err ", $System.Status.GetErrorText(tErr)
    }
    Set id=obj.%Id()
    Return sc
}

ClassMethod Populate() As %Status
{
    Do ..AddRecord(.i, "Cinnamon Sugar", "Sugar, spice and it tastes so nice!", "1_cinnamon.png")
    Write "Create new record #",i,!
    Do ..AddRecord(.i, "Vanilla Icing", "Classic taste! With creamy vanilla icing and crumbled Oreo cookie crumbles", "2_vanilla.png")
    Write "Create new record #",i,!
    Do ..AddRecord(.i, "S'Mores", "It's like donuts at the campfire. Enjoy chocolate icing with marshmallow drizzle", "3_smore.png")
    Write "Create new record #",i,!
    Do ..AddRecord(.i, "Chocolate Icing", "Simple elegance and big flavor", "4_choco.png")
    Write "Create new record #",i,!
    Do ..AddRecord(.i, "Dulce de Leche", "It's like eating churro but with soft, pillow texture of a brioche donut", "5_dulce.png")
    Write "Create new record #",i,!
    Do ..AddRecord(.i, "Brigadeiro Temptation", "Delicious Brazilian Brigadeiro Truffle Icing. It's Sweet, delicious and hard to resist", "6_brig.png")
    Write "Create new record #",i,!
    Do ..AddRecord(.i, "Sunrise Lemon Icing", "Enjoy the tastes of Spring and Sunrise Lemon Icing with blueberry drizzle", "7_sunrise.png")
    Write "Create new record #",i,!
}

Storage Default
{
<Data name="DonutsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Desc</Value>
</Value>
<Value name="4">
<Value>Img</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^dc.docx.sample.DonutsD</DataLocation>
<DefaultData>DonutsDefaultData</DefaultData>
<IdLocation>^dc.docx.sample.DonutsD</IdLocation>
<IndexLocation>^dc.docx.sample.DonutsI</IndexLocation>
<StreamLocation>^dc.docx.sample.DonutsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
