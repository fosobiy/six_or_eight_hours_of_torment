void main2() {
    // Указатель на начало видеопамяти VGA (текстовый режим)
    char* video_memory = (char*) 0xb8000;

    // Строка для вывода
    char* message = "Hello from C Function!";

    // Выводим строку: символ, затем атрибут (0x07 - серый на черном)
    int i = 0;
    while (message[i] != 0) {
        video_memory[i * 2] = message[i];     // Символ
        video_memory[i * 2 + 1] = 0x0C;       // Атрибут цвета
        i++;
    }

    // Бесконечный цикл, чтобы процессор не выполнял мусор в памяти
    while(1);
}

