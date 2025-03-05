const fs = require('fs');



// const selectionJson = 'lib/assets/fonts/selection.json';
// fs.readFile(selectionJson, 'utf8', (err, data) => {
//     if (err) {
//         console.error('Error reading file:', err);
//         return;
//     }
//     try {
//         const jsonData = JSON.parse(data);
//         jsonData.icons.forEach(element => {
//             element.icon.tags = element.icon.tags.map(tag => {
//                 return tag.replaceAll('-', '_').replaceAll(' ', '_')
//             });
//         });
//         fs.writeFile(selectionJson, JSON.stringify(jsonData), (err) => {
//             if (err) {
//                 console.error('Error writing file:', err);
//             }
//         });

//     } catch (err) {
//         console.error('Error parsing JSON:', err);
//     }
// });



const iconsDart = 'lib/src/utils/assets/icons.dart';
fs.readFile(iconsDart, 'utf8', (err, data) => {
    if (err) {
        console.error('Error reading file:', err);
        return;
    }
    try {
        const lines = data.split('\n');
        const updatedLines = lines.map(line => {

            if (line.trim().startsWith('static const IconData')) {
                const lineParts = line.trim().split(' ');
                const iconName = lineParts[3]

                const hasCapitalLetter = /[A-Z]/.test(iconName);
                if (hasCapitalLetter) {
                    const newIconName = iconName.replace(/[A-Z]/g, letter => `_${letter.toLowerCase()}`);
                    lineParts[3] = newIconName;
                }

                if (!lineParts.some(part => part.includes('fontPackage: packageName'))) {

                    const closingBracketIndex = lineParts.findIndex(part => part.includes(');'));
                    if (closingBracketIndex !== -1) {

                        lineParts[closingBracketIndex] = lineParts[closingBracketIndex].replace(');', ', fontPackage: packageName);');
                    }
                }

                return lineParts.join(' ');
            }
            return line;
        });
        const updatedData = updatedLines.join('\n');
        fs.writeFile(iconsDart, updatedData, (err) => {
            if (err) {
                console.error('Error writing file:', err);
            }
        });
    } catch (err) {
        console.error('Error parsing dart:', err);
    }
});

