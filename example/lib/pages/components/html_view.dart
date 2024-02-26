import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

const mediaHtml = '''
<!DOCTYPE html>
<html>

<head>
    <title>Notes</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>

 <flutter horizontal></flutter>

<iframe src="https://media.geeksforgeeks.org/wp-content/uploads/20210314115545/sample-video.mp4" frameborder="0" allowfullscreen="" allow="autoplay; encrypted-media" style="position: absolute; width: 100%; height: 100%; top: 0; left: 0;"></iframe>

<p>Media audio url:</p>
<figure class="media">
    <div data-oembed-url="https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3">
        <div style="position: relative; height: 0; padding-bottom: 56.2493%; pointer-events: visible;"><iframe src="https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3" frameborder="0" allowfullscreen="" allow="autoplay; encrypted-media" style="position: absolute; width: 100%; height: 100%; top: 0; left: 0;"></iframe></div>
    </div>
</figure>

<p>Media video Url:</p>
<figure class="media">
    <div data-oembed-url="https://media.geeksforgeeks.org/wp-content/uploads/20210314115545/sample-video.mp4">
      <div style="position: relative; height: 0; padding-bottom: 56.2493%; pointer-events: visible;"><iframe src="https://media.geeksforgeeks.org/wp-content/uploads/20210314115545/sample-video.mp4" frameborder="0" allowfullscreen="" allow="autoplay; encrypted-media" style="position: absolute; width: 100%; height: 100%; top: 0; left: 0;"></iframe></div>
    </div>
</figure>

<p>Links:</p>
<p><a target="_blank" rel="noopener noreferrer" href="https://google.com">https://google.com</a></p>
<p><a target="_blank" rel="noopener noreferrer" href="https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4">https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4</a></p>
</p>



   
</html>''';

const html = '''
<!DOCTYPE html>
<html>

<head>
    <title>Notes</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>

<body>
    <div class="ck-content">
        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><figure class="media"><div data-oembed-url="https://www.youtube.com/embed/tgbNymZ7vqY"><div style="position: relative; padding-bottom: 100%; height: 0; padding-bottom: 56.2493%;"><iframe src="https://www.youtube.com/embed/tgbNymZ7vqY" style="position: absolute; width: 100%; height: 100%; top: 0; left: 0;" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen=""></iframe></div></div></figure><p> </p><p> </p><p> </p><p> </p><p> </p><p> </p><p> </p><p> </p><p> </p><p> </p><p> </p><p> </p><p> </p><p><strong>Bold : Retail describes the sale of a product or service to an individual consumer for personal use</strong>. <i>I</i></p><p><i>talic: The transaction itself can occur through a number of different sales channels, such as online, in a brick-and-mortar storefront, through direct sales, or direct mail.</i> <u>Underline:</u> <u>The aspect of the sale that qualifies it as a retail transaction is that the end user is the buyer.</u></p><p> </p><p style="text-align:right;"><i><strong><u>Bold Italic Underline : Retail describes the sale of a product or service to an individual consumer for personal use.The transaction itself can occur through a number of different sales channels, such as online, in a brick-and-mortar storefront, through direct sales, or direct mail. The aspect of the sale that qualifies it as a retail transaction is that the end user is the buyer.</u></strong></i></p><p> </p><p style="text-align:center;"><s>Retail describes the sale of a product or service to an individual consumer for personal use.The transaction itself can occur through a number of different sales channels, such as online, in a brick-and-mortar storefront, through direct sales, or direct mail. The aspect of the sale that qualifies it as a retail transaction is that the end user is the buyer.</s></p><p><sup>Retail describes the sale of a product or service to an individual consumer for personal use.The transaction itself can occur through a number of different sales channels, such as online, in a brick-and-mortar storefront, through direct sales, or direct mail. The aspect of the sale that qualifies it as a retail transaction is that the end user is the buyer.</sup></p><p> </p><p style="text-align:justify;"><span style="background-color:#E6E64C;color:#E64C4C;font-family:'Comic Sans MS';">Retail describes the sale of a product or service to an individual consumer for personal use.The transaction itself can occur through a number of different sales channels, such as online, in a brick-and-mortar storefront, through direct sales, or direct mail. The aspect of the sale that qualifies it as a retail transaction is that the end user is the buyer.</span></p><p> </p><ul><li><span style="background-color:#E6E6E6;color:#994CE6;">Hardlines: things that tend to last a long time, such as appliances, cars, and furniture</span></li><li><span style="background-color:#E6E6E6;color:#4C4CE6;">Soft goods or consumables: things like clothing, shoes, and toiletries</span></li><li><span style="background-color:#E6E6E6;color:#4CE699;">Food: things like meat, cheese, produce, and baked goods</span></li><li><span style="background-color:#E6E6E6;color:#4D4D4D;">Art: things like fine art, as well as books and musical instruments</span></li></ul><p> </p><blockquote><p>Within those categories you’ll also find different types of retail stores. Some of the most common types include:</p><p>HTML:<br> </p></blockquote><div class="raw-html-embed">
    <figure class="table" style="float:left;height:200px;width:500px;"><table style="background-color:hsl(180, 75%, 60%);border:1px outset hsl(0, 75%, 60%);"><tbody><tr><td style = " border : solid 1px;" >Column1</td><td style = " border : solid 1px;" >Column2</td><td style="border-style:solid;border-width:1px;">Column3</td><td style="border-style:solid;border-width:1px;">Column4</td><td style="border-style:solid;border-width:1px;">Column5</td><td style="border-style:solid;border-width:1px;">Column6</td><td style="border-style:solid;border-width:1px;">Column7</td></tr><tr><td style="border-style:solid;border-width:1px;">Col1Row1</td><td style="border-style:solid;border-width:1px;">Col2Row1</td><td style="border-style:solid;border-width:1px;">Col3Row1</td><td style="border-style:solid;border-width:1px;">Col4Row1</td><td style="border-style:solid;border-width:1px;">Col5Row1</td><td style="border-style:solid;border-width:1px;" colspan="2">Col6Row1</td></tr><tr><td style="border-style:solid;border-width:1px;">Col1Row2</td><td style="border-style:solid;border-width:1px;">Col2Row2</td><td style="border-style:solid;border-width:1px;">Col3Row2</td><td style="border-style:solid;border-width:1px;">Col4Row2</td><td style="border-style:solid;border-width:1px;">Col5Row2</td><td style="border-style:solid;border-width:1px;">Col6Row2</td><td style="border-style:solid;border-width:1px;"> </td></tr><tr><td style="border-style:solid;border-width:1px;">Col1Row3</td><td style="border-style:solid;border-width:1px;">Col2Row3</td><td style="border-style:solid;border-width:1px;">Col3Row3</td><td style="border-style:solid;border-width:1px;">Col4Row3</td><td style="border-style:solid;border-width:1px;">Col5Row3</td><td style="border-style:solid;border-width:1px;" colspan="2">Col6Row3</td></tr><tr><td style="border-style:solid;border-width:1px;">Col1Row4</td><td style="border-style:solid;border-width:1px;">Col2Row4</td><td style="border-style:solid;border-width:1px;">Col3Row4</td><td style="border-style:solid;border-width:1px;">Col4Row4</td><td style="border-style:solid;border-width:1px;">Col5Row4</td><td style="border-style:solid;border-width:1px;">Col6Row4</td><td style="border-style:solid;border-width:1px;"> </td></tr></tbody></table></figure>
    <figure class="table" style="float:left;height:200px;width:500px;">
    <table style="background-color:hsl(180, 75%, 60%);border:1px outset hsl(0, 75%, 60%);">
        <tbody>
            <tr>
                <td style="border-style:solid;border-width:1px;">Column1</td>
                <td style="border-style:solid;border-width:1px;">Column2</td>
                <td style="border-style:solid;border-width:1px;">Column3</td>
                <td style="border-style:solid;border-width:1px;">Column4</td>
                <td style="border-style:solid;border-width:1px;">Column5</td>
                <td style="border-style:solid;border-width:1px;">Column6</td>
                <td style="border-style:solid;border-width:1px;">Column7</td>
            </tr>
            <tr>
                <td style="border-style:solid;border-width:1px;" colspan="2">
                   <p>Col1Row1</p>
                    <p>Col2Row1</p>
                </td>
                <td style="border-style:solid;border-width:1px;">Col3Row1</td>
                <td style="border-style:solid;border-width:1px;">Col4Row1</td>
                <td style="border-style:solid;border-width:1px;">Col5Row1</td>
                <td style="border-style:solid;border-width:1px;" colspan="2" rowspan="2">
                    <p>Col6Row1</p>
                    <p>Col6Row2</p>
                </td>
            </tr>
            <tr>
                <td style="border-style:solid;border-width:1px;">Col1Row2</td>
                <td style="border-style:solid;border-width:1px;" rowspan="2">
                    <p>Col2Row2</p>
                    <p>Col2Row3</p>
                </td>
                <td style="border-style:solid;border-width:1px;" colspan="2">
                    <p>Col3Row2</p>
                    <p>Col4Row2</p>
                </td>
                <td style="border-style:solid;border-width:1px;">Col5Row2</td>
            </tr>
            <tr>
                <td style="border-style:solid;border-width:1px;">Col1Row3</td>
                <td style="border-style:solid;border-width:1px;">Col3Row3</td>
                <td style="border-style:solid;border-width:1px;">Col4Row3</td>
                <td style="border-style:solid;border-width:1px;">Col5Row3</td>
                <td style="border-style:solid;border-width:1px;" colspan="2">Col6Row3</td>
            </tr>
            <tr>
                <td style="border-style:solid;border-width:1px;">Col1Row4</td>
                <td style="border-style:solid;border-width:1px;">Col2Row4</td>
                <td style="border-style:solid;border-width:1px;">Col3Row4</td>
                <td style="border-style:solid;border-width:1px;">Col4Row4</td>
                <td style="border-style:solid;border-width:1px;">Col5Row4</td>
                <td style="border-style:solid;border-width:1px;">Col6Row4</td>
                <td style="border-style:solid;border-width:1px;"> </td>
            </tr>
        </tbody>
    </table>
</figure>
    <p>
        1. This paragraph has multiple lines.
        But HTML reduces them to a single line,
        omitting the carriage return we have used.
        2.This paragraph has multiple lines.
        But HTML reduces them to a single line,
        omitting the carriage return we have used.
        3. This paragraph has multiple lines.
        But HTML reduces them to a single line,
        omitting the carriage return we have used.
        4. This paragraph has multiple lines.
        But HTML reduces them to a single line,
        omitting the carriage return we have used.
        5. This paragraph has multiple lines.
        But HTML reduces them to a single line,
        omitting the carriage return we have used.
    </p>
    <p>
        This paragraph has multiple spaces.
        But HTML reduces them all to a single
        space, omitting the extra spaces and line we have used.
    </p>

 
</div><figure class="image"></figure><p>Links: </p><p><a target="_blank" rel="noopener noreferrer" href="https://google.com">https://google.com</a></p><p><a target="_blank" rel="noopener noreferrer" href="https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4">https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4</a></p><p> </p><p> </p><p> </p><p> </p><p>Media audio url:</p><figure class="media"><div data-oembed-url="https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3"><div style="position: relative; height: 0; padding-bottom: 56.2493%; pointer-events: visible;"><iframe src="https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3" frameborder="0" allowfullscreen="" allow="autoplay; encrypted-media" style="position: absolute; width: 100%; height: 100%; top: 0; left: 0;"></iframe></div></div></figure><p> </p><p> </p><p> </p><p>Media video Url:</p><figure class="media"><div data-oembed-url="https://media.geeksforgeeks.org/wp-content/uploads/20210314115545/sample-video.mp4"><div style="position: relative; height: 0; padding-bottom: 56.2493%; pointer-events: visible;"><iframe src="https://media.geeksforgeeks.org/wp-content/uploads/20210314115545/sample-video.mp4" frameborder="0" allowfullscreen="" allow="autoplay; encrypted-media" style="position: absolute; width: 100%; height: 100%; top: 0; left: 0;"></iframe></div></div></figure><p> </p><p> </p><p>iframe/embedded video</p><figure class="media"><div data-oembed-url="https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4"><div style="position: relative; height: 0; padding-bottom: 56.2493%; pointer-events: visible;"><iframe src="https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4" frameborder="0" allowfullscreen="" allow="autoplay; encrypted-media" style="position: absolute; width: 100%; height: 100%; top: 0; left: 0;"></iframe></div></div></figure><p> </p>
    </div>

<figure class="table" style="float:left;height:200px;width:500px;">
            <table style="background-color:hsl(180, 75%, 60%);border:1px outset hsl(0, 75%, 60%);">
                <tbody>
                    <tr>
                        <td style=" border : solid 1px;">Column1</td>
                        <td style=" border : solid 1px;">Column2</td>
                        <td style="border-style:solid;border-width:1px;">Column3</td>
                        <td style="border-style:solid;border-width:1px;">Column4</td>
                        <td style="border-style:solid;border-width:1px;">Column5</td>
                        <td style="border-style:solid;border-width:1px;">Column6</td>
                        <td style="border-style:solid;border-width:1px;">Column7</td>
                    </tr>
                    <tr>
                        <td style="border-style:solid;border-width:1px;">Col1Row1</td>
                        <td style="border-style:solid;border-width:1px;">Col2Row1</td>
                        <td style="border-style:solid;border-width:1px;">Col3Row1</td>
                        <td style="border-style:solid;border-width:1px;">Col4Row1</td>
                        <td style="border-style:solid;border-width:1px;">Col5Row1</td>
                        <td style="border-style:solid;border-width:1px;" colspan="2">Col6Row1</td>
                    </tr>
                    <tr>
                        <td style="border-style:solid;border-width:1px;">Col1Row2</td>
                        <td style="border-style:solid;border-width:1px;">Col2Row2</td>
                        <td style="border-style:solid;border-width:1px;">Col3Row2</td>
                        <td style="border-style:solid;border-width:1px;">Col4Row2</td>
                        <td style="border-style:solid;border-width:1px;">Col5Row2</td>
                        <td style="border-style:solid;border-width:1px;">Col6Row2</td>
                        <td style="border-style:solid;border-width:1px;"> </td>
                    </tr>
                    <tr>
                        <td style="border-style:solid;border-width:1px;">Col1Row3</td>
                        <td style="border-style:solid;border-width:1px;">Col2Row3</td>
                        <td style="border-style:solid;border-width:1px;">Col3Row3</td>
                        <td style="border-style:solid;border-width:1px;">Col4Row3</td>
                        <td style="border-style:solid;border-width:1px;">Col5Row3</td>
                        <td style="border-style:solid;border-width:1px;" colspan="2">Col6Row3</td>
                    </tr>
                    <tr>
                        <td style="border-style:solid;border-width:1px;">Col1Row4</td>
                        <td style="border-style:solid;border-width:1px;">Col2Row4</td>
                        <td style="border-style:solid;border-width:1px;">Col3Row4</td>
                        <td style="border-style:solid;border-width:1px;">Col4Row4</td>
                        <td style="border-style:solid;border-width:1px;">Col5Row4</td>
                        <td style="border-style:solid;border-width:1px;">Col6Row4</td>
                        <td style="border-style:solid;border-width:1px;"> </td>
                    </tr>
                </tbody>
            </table>
        </figure>
</body>

</html>
  ''';

const imgHtml = '''
<!DOCTYPE html>
<html>

<head>
    <title>Notes</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>

<body>
    <div class="ck-content">
        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
        <h1 style="margin-left:0px;"><strong>What Is Retail?</strong></h1>
        <p style="margin-left:0px;">Definitions & Examples of Retail</p>
        <p style="margin-left:0px;">By</p>
        <p style="margin-left:0px;"><a target="_blank" rel="noopener noreferrer" href="https://www.thebalancemoney.com/barbara-farfan-2891581"><strong><u>Barbara Farfan</u></strong></a></p>
        <p style="margin-left:0px;"><a target="_blank" rel="noopener noreferrer" href="https://www.thebalancemoney.com/barbara-farfan-2891581"><strong>Barbara Farfan</strong></a></p>
        <p style="margin-left:0px;">Barbara Farfan has 20 years of experience as a business consultant in the retail industry.</p>
        <p style="margin-left:0px;"><a target="_blank" rel="noopener noreferrer" href="https://www.thebalancemoney.com/about-us-5104704#toc-editorial-guidelines">LEARN ABOUT OUR EDITORIAL POLICIES</a></p>
        <p style="margin-left:0px;">Updated on November 29, 2022</p>
        <p style="margin-left:0px;">Reviewed by <a target="_blank" rel="noopener noreferrer" href="https://www.thebalancemoney.com/david-kindness-4800820"><strong>David Kindness</strong></a></p>
        <p style="margin-left:0px;"><img src="https://www.thebalancemoney.com/thmb/K-VtpATDDngviEmSdyDmZooHpPE=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/customer-looking-at-mens-accessories-with-shop-owner-in-mens-boutique-814558864-5b86d6a746e0fb002530bf8d.jpg" alt="Customer looking at mens accessories with shop owner in mens boutique" srcset="https://www.thebalancemoney.com/thmb/r3zacaHwOZA7VEdgP7UN8LFkpNU=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/customer-looking-at-mens-accessories-with-shop-owner-in-mens-boutique-814558864-5b86d6a746e0fb002530bf8d.jpg 750w" sizes="100vw" width="5500"></p>
        <p style="margin-left:0px;">PHOTO: THOMAS BARWICK / GETTY IMAGES</p>
        <p style="margin-left:0px;">Retail is a very broad term that encompasses a huge industry, employing millions of people and generating trillions of dollars per year in sales revenue. Retail is the sale of goods to consumers—not for them to sell, but for use and consumption by the purchaser.</p>
        <p style="margin-left:0px;">This knowledge can help you gain an understanding of the processes involved in getting merchandise to the shelves and the effect a supply chain can have on pricing and sales.</p>
        <h2 style="margin-left:0px;"><strong>What Is Retail?</strong></h2>
        <p style="margin-left:0px;">Retail involves the sale of merchandise from a single point of purchase directly to a customer who intends to use that product. The single point of purchase could be a brick-and-mortar retail store, an internet shopping website, or a catalog.</p>
        <p style="margin-left:0px;">Retailing is all about attracting consumers through product displays and marketing. Inventory must be kept, shelves must be kept full, and payments have to be collected. Retailers are more than places to purchase merchandise, however—they provide manufacturers an outlet so that they can focus on creating their products.</p>
        <h3 style="margin-left:0px;">Note</h3>
        <p style="margin-left:0px;">In essence, retailing is the culmination of many different processes brought together to create sales.</p>
        <h2 style="margin-left:0px;"><strong>How Does Retailing Work?</strong></h2>
        <p style="margin-left:0px;">Retailers rely on a system that supplies them with merchandise to market to consumers. To acquire inventory and ensure they have the products they want to sell, relationships must be established with businesses that operate within the retail supply chain.</p>
        <p style="margin-left:0px;"> </p>
        <p style="margin-left:0px;">The retail supply chain consists of manufacturers, wholesalers, retailers, and the consumer (end-user). The wholesaler is directly connected to the manufacturer, while the retailer is connected to the wholesaler.</p>
        <p style="margin-left:0px;">The roles of the key players in a typical retail supply chain are:</p>    
        <ul>
            <li><strong>Manufacturers</strong>: Produce goods using machines, raw materials, and labor</li>
            <li><strong>Wholesalers</strong>: Purchase finished goods from the manufacturers and sell those goods to retailers in large bulk quantities</li>
            <li><strong>Retailers:</strong> Sell the goods in small quantities to the end-user at a higher price, theoretically at the manufacturers suggested retail price</li>
            <li><strong>Consumers</strong>: Buy the goods from the retailer for personal use</li>
        </ul>

        <h2>List support:</h2>
      <ol>
            <li>This</li>
            <li><p>is</p></li>
            <li>an</li>
            <li>
            ordered
            <ul>
            <li>With<br /><br />...</li>
            <li>a</li>
            <li>nested</li>
            <li>unordered
            <ol style="list-style-type: lower-alpha;" start="5">
            <li>With a nested</li>
            <li>ordered list</li>
            <li>with a lower alpha list style</li>
            <li>starting at letter e</li>
            </ol>
            </li>
            <li>list</li>
            </ul>
            </li>
            <li>list! Lorem ipsum dolor sit amet.</li>
            <li><h2>Header 2</h2></li>
            <h2><li>Header 2</li></h2>
      </ol>
        <p style="margin-left:0px;"><img class="image_resized" style="width:600px;" src="https://www.thebalancemoney.com/thmb/YNFRLe17GA_UbJ2CfcFBRhlZLzY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/what-is-retail-2892238-v3-5bb50aa746e0fb0026555f98.png" alt="retail supply chain" srcset="https://www.thebalancemoney.com/thmb/lAyRaeJPv_m_jnLYCnyY_YlzM-g=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/what-is-retail-2892238-v3-5bb50aa746e0fb0026555f98.png 750w" sizes="100vw" width="1500"></p>
    </div>
</body>

</html>
  ''';
const tableHtml = '''
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<figure class="table">
    <table>
        <tbody>
            <tr>
                <td style="border-style:solid;">qwerq</td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
            </tr>
            <tr>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;">
                    21323<sup>12</sup>
                </td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;">
                </td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;">
                    <span style="font-family:'Comic Sans MS';">1231wef</span>
                </td>
                <td style="border-style:solid;">
                    <span style="font-size:8px;">123456</span>
                </td>
                <td style="border-style:solid;">
                    <span style="color:#E6994C;">12345</span>
                </td>
                <td style="border-style:solid;">
                    <span style="background-color:#99E64C;">12345</span>
                </td>
                <td style="border-style:solid;">
                    <ul>
                        <li>123</li>
                        <li>1243</li>
                    </ul>
                </td>
            </tr>
            <tr>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;">123</td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
            </tr>
            <tr>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;">123</td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;">
                    <ol>
                        <li>12345</li>
                        <li>32435</li>
                    </ol>
                </td>
            </tr>
            <tr>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;">
                    <strong>213</strong>
                </td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;">
                    <p style="margin-left:80px;">12345</p>
                </td>
            </tr>
            <tr>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;">
                    <i>213</i>
                </td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;"></td>
                <td style="border-style:solid;">
                    <blockquote>
                        <p>12345</p>
                    </blockquote>
                </td>
            </tr>
            <tr>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;">
                    <u>213</u>
                </td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;">
                    <div class="raw-html-embed">12345678</div>
                </td>
            </tr>
            <tr>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;">ksdlkjhs dajflh</td>
                <td style="border-style:solid;border-width:1px;">
                    <p style="text-align:right;">123</p>
                </td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;">
                    <s>213</s>
                </td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
            </tr>
            <tr>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;">231</td>
                <td style="border-style:solid;border-width:1px;"></td>
            </tr>
            <tr>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;"></td>
                <td style="border-style:solid;border-width:1px;">
                    <p>1231232basdvc ns/,vn d</p>
                    <p>vd vdfsbv'dsfv</p>
                    <p>a vb;sdf vbsd; vbfd; vbj</p>
                </td>
            </tr>
        </tbody>
    </table>
</figure>


  ''';

const htmlData = r"""
<p id='top'><a href='#bottom'>Scroll to bottom</a></p>
      <h1>Header 1</h1>
      <h2>Header 2</h2>
      <h3>Header 3</h3>
      <h4>Header 4</h4>
      <h5>Header 5</h5>
      <h6>Header 6</h6>
      
      <h2>Inline Styles:</h2>
      <p>The should be <span style='color: blue;'>BLUE style='color: blue;'</span></p>
      <p>The should be <span style='color: red;'>RED style='color: red;'</span></p>
      <p>The should be <span style='color: rgba(0, 0, 0, 0.10);'>BLACK with 10% alpha style='color: rgba(0, 0, 0, 0.10);</span></p>
      <p>The should be <span style='color: rgb(0, 97, 0);'>GREEN style='color: rgb(0, 97, 0);</span></p>
      <p>The should be <span style='background-color: red; color: rgb(0, 97, 0);'>GREEN style='color: rgb(0, 97, 0);</span></p>
      
      <h2>Text Alignment</h2>
      <p style="text-align: center;"><span style="color: rgba(0, 0, 0, 0.95);">Center Aligned Text</span></p>
      <p style="text-align: right;"><span style="color: rgba(0, 0, 0, 0.95);">Right Aligned Text</span></p>
      <p style="text-align: justify;"><span style="color: rgba(0, 0, 0, 0.95);">Justified Text</span></p>
      <p style="text-align: center;"><span style="color: rgba(0, 0, 0, 0.95);">Center Aligned Text</span></p>
      
      <h2>Margins</h2>
      <div style="width: 350px; height: 20px; text-align: center; background-color: #ff9999;">Default Div (width 350px height 20px)</div>
      <div style="width: 350px; height: 20px; text-align: center; background-color: #ffff99; margin-left: 3em;">margin-left: 3em</div>
      <div style="width: 350px; height: 20px; text-align: center; background-color: #99ff99; margin: auto;">margin: auto</div>
      <div style="width: 350px; height: 20px; text-align: center; background-color: #ff99ff; margin: 15px auto;">margin: 15px auto</div>
      <div style="width: 350px; height: 20px; text-align: center; background-color: #9999ff; margin-left: auto;">margin-left: auto</div>
      <div style="width: 350px; height: 20px; text-align: center; background-color: #99ffff; margin-right: auto;">margin-right: auto</div>
      <div style="width: 350px; height: 20px; text-align: center; background-color: #999999; margin-left: auto; margin-right: 3em;">margin-left: auto; margin-right: 3em</div>
      
      <h4>Margin Auto on Image</h4>
      <p>display:inline-block; margin: auto; (should not center):</p>
      <img alt='' style="margin: auto;" width="100" src="https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_92x30dp.png">
      <p>display:block margin: auto; (should center):</p>
      <img alt='' style="display: block; margin: auto;" width="100" src="https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_92x30dp.png">
      
      <h2>Support for <code>sub</code>/<code>sup</code></h2>
      Solve for <var>x<sub>n</sub></var>: log<sub>2</sub>(<var>x</var><sup>2</sup>+<var>n</var>) = 9<sup>3</sup>
      <p>One of the most <span>common</span> equations in all of physics is <br /><var>E</var>=<var>m</var><var>c</var><sup>2</sup>.</p>
      
      <h2>Ruby Support:</h2>
      <p>
        <ruby>
          漢<rt>かん</rt>
          字<rt>じ</rt>
        </ruby>
        &nbsp;is Japanese Kanji.
      </p>
      
      <h2>Support for maxLines:</h2>
      <h5>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vestibulum sapien feugiat lorem tempor, id porta orci elementum. Fusce sed justo id arcu egestas congue. Fusce tincidunt lacus ipsum, in imperdiet felis ultricies eu. In ullamcorper risus felis, ac maximus dui bibendum vel. Integer ligula tortor, facilisis eu mauris ut, ultrices hendrerit ex. Donec scelerisque massa consequat, eleifend mauris eu, mollis dui. Donec placerat augue tortor, et tincidunt quam tempus non. Quisque sagittis enim nisi, eu condimentum lacus egestas ac. Nam facilisis luctus ipsum, at aliquam urna fermentum a. Quisque tortor dui, faucibus in ante eget, pellentesque mattis nibh. In augue dolor, euismod vitae eleifend nec, tempus vel urna. Donec vitae augue accumsan ligula fringilla ultrices et vel ex.</h5>
      
     
      <h2>Table support (With custom styling!):</h2>
      <table>
      <colgroup>
        <col width="200" />
        <col span="2" width="150" />
      </colgroup>
      <thead>
      <tr><th>One</th><th>Two</th><th>Three</th></tr>
      </thead>
      <tbody>
      <tr>
        <td rowspan='2'>Rowspan<br>Rowspan<br>Rowspan<br>Rowspan<br>Rowspan<br>Rowspan<br>Rowspan<br>Rowspan<br>Rowspan<br>Rowspan<br>Rowspan<br>Rowspan<br>Rowspan<br>Rowspan</td><td>Data</td><td>Data</td>
      </tr>
      <tr>
        <td colspan="2"><blockquote cite="http://www.worldwildlife.org/who/index.html">
For 50 years, WWF has been protecting the future of nature. 
</blockquote></td>
      </tr>
      </tbody>
      <tfoot>
      <tr><td>fData</td><td>fData</td><td>fData</td></tr>
      </tfoot>
      </table>
      
      <h2>List support:</h2>
      <ol>
            <li>This</li>
            <li><p>is</p></li>
            <li>an</li>
            <li>
            ordered
            <ul>
            <li>With<br /><br />...</li>
            <li>a</li>
            <li>nested</li>
            <li>unordered
            <ol style="list-style-type: lower-alpha;" start="5">
            <li>With a nested</li>
            <li>ordered list</li>
            <li>with a lower alpha list style</li>
            <li>starting at letter e</li>
            </ol>
            </li>
            <li>list</li>
            </ul>
            </li>
            <li>list! Lorem ipsum dolor sit amet.</li>
            <li><h2>Header 2</h2></li>
            <h2><li>Header 2</li></h2>
      </ol>
      
      <h2>Link support:</h2>
      <p>
        Linking to <a href='https://github.com'>websites</a> has never been easier.
      </p>
      
      <h2>Image support:</h2>
      
      <table class="second-table">
      <tr><td>Network png</td><td><img width="200" alt='xkcd' src='https://imgs.xkcd.com/comics/commemorative_plaque.png' /></td></tr>
      <tr><td>Local asset png</td><td><img src='asset:assets/html5.png' width='100' /></td></tr>
      <tr><td>Local asset svg</td><td><img src='asset:assets/mac.svg' width='100' /></td></tr>
      <tr><td>Data uri (with base64 support)</td>
      <td><img alt='Red dot (png)' src='data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==' />
      <img alt='Green dot (base64 svg)' src='data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB2aWV3Qm94PSIwIDAgMzAgMjAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxjaXJjbGUgY3g9IjE1IiBjeT0iMTAiIHI9IjEwIiBmaWxsPSJncmVlbiIvPgo8L3N2Zz4=' />
      <img alt='Green dot (plain svg)' src='data:image/svg+xml,%3C?xml version="1.0" encoding="UTF-8"?%3E%3Csvg viewBox="0 0 30 20" xmlns="http://www.w3.org/2000/svg"%3E%3Ccircle cx="15" cy="10" r="10" fill="yellow"/%3E%3C/svg%3E' />
      </td></tr>
      <tr><td>Custom image render</td><td><img src='https://flutter.dev/images/flutter-mono-81x100.png' /></td></tr>
      <tr><td>Broken network image</td><td><img alt='Broken network image alt text' src='https://www.example.com/image.png' /></td></tr>
      </table>
      
      <h2 id='middle'>SVG support:</h2>
      <svg id='svg1' viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'>
            <circle r="32" cx="35" cy="65" fill="#F00" opacity="0.5"/>
            <circle r="32" cx="65" cy="65" fill="#0F0" opacity="0.5"/>
            <circle r="32" cx="50" cy="35" fill="#00F" opacity="0.5"/>
      </svg>
      
      <h2>Custom Element Support:</h2>
      Inline: &lt;bird&gt;&lt;/bird&gt; becomes: <bird></bird>.
      <br />
      
      Block: &lt;flutter&gt;&lt;/flutter&gt; becomes:
      <flutter></flutter>
      and &lt;flutter horizontal&gt;&lt;/flutter&gt; becomes:
      <flutter horizontal></flutter>
      
      <h2>MathML Support:</h2>
      <math>
      <mrow>
        <mi>x</mi>
        <mo>=</mo>
        <mfrac>
          <mrow>
            <mrow>
              <mo>-</mo>
              <mi>b</mi>
            </mrow>
            <mo>&PlusMinus;</mo>
            <msqrt>
              <mrow>
                <msup>
                  <mi>b</mi>
                  <mn>2</mn>
                </msup>
                <mo>-</mo>
                <mrow>
                  <mn>4</mn>
                  <mo>&InvisibleTimes;</mo>
                  <mi>a</mi>
                  <mo>&InvisibleTimes;</mo>
                  <mi>c</mi>
                </mrow>
              </mrow>
            </msqrt>
          </mrow>
          <mrow>
            <mn>2</mn>
            <mo>&InvisibleTimes;</mo>
            <mi>a</mi>
          </mrow>
        </mfrac>
      </mrow>
      </math>
      <math>
        <munderover >
          <mo> &int; </mo>
          <mn> 0 </mn>
          <mi> 5 </mi>
        </munderover>
        <msup>
          <mi>x</mi>
          <mn>2</mn>
       </msup>
        <mo>&sdot;</mo>
        <mi>d</mi><mi>x</mi>
        <mo>=</mo>
        <mo>[</mo>
        <mfrac>
          <mn>1</mn>
          <mi>3</mi>
       </mfrac>
       <msup>
          <mi>x</mi>
          <mn>3</mn>
       </msup>
       <msubsup>
          <mo>]</mo>
          <mn>0</mn>
          <mn>5</mn>
       </msubsup>
       <mo>=</mo>
       <mfrac>
          <mn>125</mn>
          <mi>3</mi>
       </mfrac>
       <mo>-</mo>
       <mn>0</mn>
       <mo>=</mo>
       <mfrac>
          <mn>125</mn>
          <mi>3</mi>
       </mfrac>
      </math>
      <br />
      <math>
        <msup>
          <mo>sin</mo>
          <mn>2</mn>
        </msup>
        <mo>&theta;</mo>
        <mo>+</mo>
        <msup>
          <mo>cos</mo>
          <mn>2</mn>
        </msup>
        <mo>&theta;</mo>
        <mo>=</mo>
        <mn>1</mn>
      </math>
      
      <h2>Tex Support with the custom tex tag:</h2>
      <tex>i\hbar\frac{\partial}{\partial t}\Psi(\vec x,t) = -\frac{\hbar}{2m}\nabla^2\Psi(\vec x,t)+ V(\vec x)\Psi(\vec x,t)</tex>
      <h2>blockquote:</h2>
      <blockquote cite="http://www.worldwildlife.org/who/index.html">
For 50 years, WWF has been protecting the future of nature. The world's leading conservation organization, WWF works in 100 countries and is supported by 1.2 million members in the United States and close to 5 million globally.
</blockquote>
      <p id='bottom'><a href='#top'>Scroll to top</a></p>
""";

const testHtml = '''
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><h1> </h1><h1>Heading1 </h1><h2>Heading 2</h2><h3>Heading 3</h3><h4>Heading 4</h4><h5>Heading 2</h5><h6>Heading 2</h6><p> </p><h2><strong>Bold : </strong></h2><p><strong>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</strong></p><p> </p><h2><i>Italic : </i></h2><p><i>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</i></p><p> </p><h2><u>Italic</u><i> : </i></h2><p><i><u>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</u></i></p><p> </p><p> </p><h2><s>Scratch</s><i> : </i></h2><p><i><s>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</s></i></p><p> </p><p> </p><h2>X<sup>2</sup></h2><p>565656767<sup>56566656</sup></p><p> </p><h2>Left Align: </h2><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p><p> </p><h2 style="text-align:right;">Right Align: </h2><p style="text-align:right;">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p><p style="text-align:right;"> </p><p style="text-align:right;"> </p><h2 style="text-align:center;">Center Align: </h2><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p><p> </p><p> </p><h2 style="text-align:justify;">Justify Align: </h2><blockquote><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p></blockquote><p style="text-align:justify;"> </p><p style="text-align:center;"> </p><h2>Font: </h2><p><span style="font-family:'Comic Sans MS';"><strong>Comic</strong>: Lorem ipsum dolor sit amet, consectetur adipiscing elit</span>,<span style="font-family:'Courier New';"> </span></p><p><span style="font-family:'Courier New';"><strong>Courier new:</strong> sed do eiusmod tempor incididunt ut labore et dolore magna aliqua</span>. </p><p><strong>Georgia</strong>: <span style="font-family:Georgia;">Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat</span>. </p><p><span style="font-family:Verdana;"><strong>Verdana</strong></span>: <span style="font-family:Verdana;">Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</span></p><p> </p><h2><span style="font-family:Verdana;">Font Size</span></h2><p><span style="font-family:'Comic Sans MS';font-size:11px;"><strong>Comic</strong>: Lorem ipsum dolor sit amet, consectetur adipiscing elit</span><span style="font-size:11px;">,</span><span style="font-family:'Courier New';font-size:11px;"> </span></p><p><span style="font-family:'Courier New';font-size:26px;"><strong>Courier new:</strong> sed do eiusmod tempor incididunt ut labore et dolore magna aliqua</span><span style="font-size:26px;">.</span><span style="font-size:36px;"> </span></p><p><span style="font-size:18px;"><strong>Georgia</strong>: </span><span style="font-family:Georgia;font-size:18px;">Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat</span><span style="font-size:18px;">. </span></p><p><span style="font-family:Verdana;font-size:22px;"><strong>Verdana</strong></span><span style="font-size:22px;">: </span><span style="font-family:Verdana;font-size:22px;">Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</span></p><p> </p><h2>Color:</h2><p><span style="color:#E64C4C;">Red: Lorem ipsum dolor sit amet, consectetur adipiscing elit</span>, </p><p><span style="color:#994CE6;">Purple: sed do eiusmod tempor incididunt ut labore et dolore magna aliqua</span>. </p><p><span style="color:#E6E64C;">Yellow: Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur</span>. <span style="color:#4C99E6;">Excepteur Blue: sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</span></p><p style="text-align:justify;"> </p><h2 style="text-align:justify;"><span style="background-color:#4C99E6;">Color Background</span></h2><p style="text-align:justify;"><span style="background-color:#E6994C;">Orange: nm,fnv,mnbgmbnmm</span></p><p style="text-align:justify;"><span style="background-color:#E64C4C;">Red: </span><span style="background-color:#E64C4C;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></p><p style="text-align:justify;"><span style="background-color:#994CE6;">Purple: </span><span style="background-color:#994CE6;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></p><p><span style="background-color:#E6E64C;">Yellow: </span><span style="background-color:#E6E64C;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></p><p> </p><p> </p><h2><span style="font-family:Verdana;">List-Disc</span></h2><ul style="list-style-type:disc;"><li><span>Purple: </span><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit'</span></li><li><span>Purple: </span><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li><li><span>Purple: </span><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li><li><span>Purple: </span><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li><li><span>Purple: </span><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li></ul><p> </p><h2><span style="font-family:Verdana;">List-Circle</span></h2><ul style="list-style-type:circle;"><li><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li><li><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li><li><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li><li><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li><li><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li></ul><p> </p><h2><span style="background-color:#FFFFFF;font-family:Verdana;">List - Square</span></h2><ul style="list-style-type:square;"><li><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li><li><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li><li><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li><li><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li><li><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li><li><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li></ul><p> </p><p><span style="background-color:#FFFFFF;font-family:Verdana;">List-Number</span></p><ol style="list-style-type:decimal;"><li><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li><li><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li><li><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li><li><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li><li><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li><li><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li></ol><p> </p><h2><span style="font-family:Verdana;">List - Alpha</span></h2><ol style="list-style-type:upper-latin;"><li><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li><li><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li><li><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li><li><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li><li><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li><li><span style="background-color:#FFFFFF;font-family:Verdana;">Duis aute irure dolor in reprehenderit</span></li></ol><blockquote><h2><span style="background-color:#FFFFFF;font-family:Verdana;">Blockquote:</span></h2></blockquote><blockquote><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p></blockquote><p style="text-align:justify;"> </p><div class="raw-html-embed">


<title>Page Title</title>



<h1>This is a Heading</h1>
<p>This is a paragraph.</p>


</div><h2> </h2><figure class="table" style="float:left;"><table style="background-color:hsl(0, 0%, 60%);border:1px solid hsl(0, 75%, 60%);"><tbody><tr><td style="border-style:solid;border-width:1px;">Test 1</td><td style="border-style:solid;border-width:1px;">Test 1</td><td style="border-style:solid;border-width:1px;">Test 1</td><td style="border-style:solid;border-width:1px;">Test 1</td><td style="border-style:solid;border-width:1px;">Test 1</td><td style="border-style:solid;border-width:1px;">Test 1</td><td style="border-style:solid;border-width:1px;">Test 1</td><td style="border-style:solid;border-width:1px;">Test 1</td></tr><tr><td rowspan="2"><p>Test Row Merge</p><p>Test Row Merge</p></td><td colspan="2"><p>Test Column Merge</p><p>Test Column Merge</p></td><td style="border-style:solid;border-width:1px;"><blockquote><p>Txt with <i>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</i></p></blockquote></td><td style="border-style:solid;border-width:1px;"><p>List-Numbered</p><ol><li>Test1</li><li>tes2</li></ol></td><td style="border-style:solid;border-width:1px;"><p>List - Disc</p><ul style="list-style-type:disc;"><li>test 1</li><li>test 2</li></ul></td><td style="border-style:solid;border-width:1px;"><strong>Bold</strong>  <i>Italic</i> <u>Underline</u> <s>Scratch</s></td><td style="border-style:solid;border-width:1px;">12345<sup>1234</sup></td></tr><tr><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td></tr><tr><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td></tr><tr><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td></tr><tr><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td><td style="border-style:solid;border-width:1px;"> </td></tr></tbody></table></figure><h2>Link:</h2><p><a target="_blank" rel="noopener noreferrer" href="https://zebra.com">https://zebra.com</a></p><p> </p><h2>Media: Audio</h2><figure class="media"><div data-oembed-url="https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3"><div style="position: relative; height: 0; padding-bottom: 56.2493%; pointer-events: visible;"><iframe src="https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3" frameborder="0" allowfullscreen="" allow="autoplay; encrypted-media" style="position: absolute; width: 100%; height: 100%; top: 0; left: 0;"></iframe></div></div></figure><h2>Media: Video</h2><p> </p><figure class="media"><div data-oembed-url="https://media.geeksforgeeks.org/wp-content/uploads/20210314115545/sample-video.mp4"><div style="position: relative; height: 0; padding-bottom: 56.2493%; pointer-events: visible;"><iframe src="https://media.geeksforgeeks.org/wp-content/uploads/20210314115545/sample-video.mp4" frameborder="0" allowfullscreen="" allow="autoplay; encrypted-media" style="position: absolute; width: 100%; height: 100%; top: 0; left: 0;"></iframe></div></div></figure>

''';

class HtmlPreview extends StatelessWidget {
  const HtmlPreview({super.key});

  @override
  Widget build(BuildContext context) {
    String htmlContent =
        '''<p style="margin-left:0px;"><br><span style="color:#202122;font-family:'Arial',sans-serif;font-size:10.5pt;"><strong>Birds</strong> are a group of </span><a target="_blank" rel="noopener noreferrer\" href="https://en.wikipedia.org/wiki/Warm-blooded"><span style="color:#3366CC;font-family:'Arial',sans-serif;font-size:10.5pt;">warm-blooded</span></a>
    
    ''';
    final colorHtml =
        '''<p><span style=\"color:#e6ffff\">blue</span><br/><span style=\"color:#303F9F\">PURPLE</span><br/><span style=\"color:#D32F2F\">red</span><br/><span style=\"color:#00796B\">Green</span><br/><span style=\"color:#FFF176\">YELLOW</span><br/><span style=\"color:#000000\">Black </span><br/><span style=\"color:#EEEEEE\">Gray</span></p>''';
    final htmlList = [mediaHtml, htmlContent, html, htmlData, colorHtml];
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Html Preview'),
      ),
      body: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          final data = htmlList[index];
          return ZdsHtmlContainer(
            data,
            showReadMore: false,
          );
        },
        itemCount: htmlList.length,
        padding: EdgeInsets.zero,
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(thickness: 2).paddingOnly(bottom: 10, top: 10),
      ),
      // SingleChildScrollView(child: ZdsHtmlContainer(mediaHtml, containerWidth: MediaQuery.of(context).size.width,)),
    );
  }
}
