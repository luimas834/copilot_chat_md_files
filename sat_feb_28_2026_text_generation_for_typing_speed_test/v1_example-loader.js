const texts = fs.readFileSync('easy.txt', 'utf-8').split('\n\n');
// texts.length === 50
const randomText = texts[Math.floor(Math.random() * texts.length)];