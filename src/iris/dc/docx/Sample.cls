Class dc.docx.Sample
{

Parameter YOURPATH = "/irisrun/repo/assets/";

ClassMethod CreateDocument()
{
    Do ..Create(..#YOURPATH)
}

ClassMethod ReadTale()
{
    Do ..DogsTale(..#YOURPATH)
}

ClassMethod ReadDocument()
{
    Do ..Read(..#YOURPATH)
}

ClassMethod Create(path As %String) [ Language = python ]
{
    from docx import Document
    from docx.enum.style import WD_STYLE_TYPE
    from docx.shared import Pt
    import iris
    import pandas as pd

    document = Document()
    document.add_heading('The Lord of the Donuts', 0)
    document.add_heading('best donut from middle earth', 2)
    document.add_picture(path + 'donut.png')

    paragraph = document.add_paragraph('One donut to rule them all, \n')
    paragraph.add_run('One').bold = True
    paragraph.add_run(' donut to ')
    paragraph.add_run('find them,').italic = True
    paragraph.add_run(' One').bold = True
    paragraph.add_run(' donut to bring them all, \nAnd with sugar bind them\n')

    font_styles = document.styles
    font_charstyle = font_styles.add_style('customStyle', WD_STYLE_TYPE.CHARACTER)
    font_object = font_charstyle.font
    font_object.size = Pt(15)
    font_object.name = 'Book Antiqua'
    run = paragraph.add_run('In the Land of Sprinkles where the sweetness lie','customStyle')

    steps = dict(coating = ['Powndered Sugar', 'Glazed', 'Chocolate Icing'],
        topping = ['Sprinkles Rainbow','Chopped Peanuts'],
        drizzle = ['Hot fudge', 'Marshmalow', 'Salted Caramel']
    )

    document.add_heading('How to order', 2)
    document.add_paragraph('Start with a Coating,', style='List Number')
    for coat in steps['coating']:
        document.add_paragraph(coat, style='List Bullet')

    document.add_paragraph('Pick a Topping,', style='List Number')
    for top in steps['topping']:
        document.add_paragraph(top, style='List Bullet')

    document.add_paragraph('Choose a Drizzle', style='List Number')
    for drizzle in steps['drizzle']:
        document.add_paragraph(drizzle, style='List Bullet')

    table = document.add_table(rows=1, cols=4)
    table.style = "Table Grid"
    heading_row = table.rows[0].cells
    heading_row[0].text = 'ID'
    heading_row[1].text = 'Image'
    heading_row[2].text = 'Product'
    heading_row[3].text = 'Description'

    rs = iris.sql.exec('SELECT id, img, name, "desc" FROM dc_docx_sample.Donuts')
    df = rs.dataframe()
    for idx in df.index:
        row_cells = table.add_row().cells
        row_cells[0].text = str(df['id'][idx])
        image_cell = row_cells[1].add_paragraph('')
        image_cell.add_run().add_picture(path + 'img/' + df['img'][idx])
        row_cells[2].text = str(df['name'][idx])
        row_cells[3].text = str(df['desc'][idx])

    document.save(path + "document.docx")
}

ClassMethod DogsTale(path As %String) [ Language = python ]
{
    from docx import Document
    doc = Document(path + "dogs_tale.docx")

    print(len(doc.paragraphs))

    p = doc.paragraphs[2]
    for run in p.runs:
        aux = ''
        if (run.bold): aux = '// has Bold style'
        if (run.italic): aux = '// has Italic style'
        print(run.text, aux + '\n')

    fulltext = []
    for p in doc.paragraphs:
        fulltext.append(p.text)
    print(fulltext)
}

ClassMethod Read(path As %String) [ Language = python ]
{
    from docx import Document
    doc = Document(path + "order.docx")

    fulltext = []
    for p in doc.paragraphs:
        fulltext.append(p.text)
    print(fulltext)

    tables = doc.tables
    data = {}
    cols = {}
    for table in tables:
        key = None
        for i, row in enumerate(table.rows):
            for col, cell in enumerate(row.cells):
                text = cell.text
                if i == 0:
                    cols[col] = text
                    data[text] = []
                    continue
                data[cols[col]].append(text)
    print(data)
}

}
