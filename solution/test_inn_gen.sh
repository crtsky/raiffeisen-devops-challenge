#!/bin/bash

SCRIPT_NAME="inn_gen.sh"

# Функция для проверки контрольной суммы ИНН
validate_inn() {
    local INN=$1
    local -a COEFFICIENTS=(2 4 10 3 5 9 4 6 8)
    local SUM=0

    for (( i=0; i<9; i++ )); do
        DIGIT=${INN:$i:1}
        SUM=$((SUM + DIGIT * COEFFICIENTS[i]))
    done

    CALCULATED_CHECKSUM=$(( (SUM % 11) % 10 ))
    ACTUAL_CHECKSUM=${INN:9:1}

    if [[ $CALCULATED_CHECKSUM -eq $ACTUAL_CHECKSUM ]]; then
        return 0
    else
        return 1
    fi
}

test_inn_generation() {
    echo "Тестирование скрипта генерации ИНН..."
    echo "-----------------------------------"

    # Тест 1: Проверка формата вывода
    OUTPUT=$(./${SCRIPT_NAME})
    if [[ ${#OUTPUT} -eq 10 ]]; then
        echo "✅ Тест 1 пройден: ИНН имеет 10 цифр"
    else
        echo "❌ Тест 1 не пройден: ИНН не имеет 10 цифр"
    fi

    # Тест 2: Проверка контрольной суммы
    if validate_inn "$OUTPUT"; then
        echo "✅ Тест 2 пройден: Контрольная сумма верна"
    else
        echo "❌ Тест 2 не пройден: Контрольная сумма не верна"
        echo "Сгенерированный ИНН: $OUTPUT"
    fi

    # Тест 3: Множественные запуски
    echo -e "\nТест 3: Проверка уникальности при многократном запуске"
    declare -A generated_inns
    DUPLICATES=0
    TESTS=100

    for ((I=1; I<=TESTS; I++)); do
        INN=$(./${SCRIPT_NAME})
        if [[ -n "${generated_inns[$INN]}" ]]; then
            ((DUPLICATES++))
        else
            generated_inns[$INN]=1
        fi
    done

    if [[ $DUPLICATES -eq 0 ]]; then
        echo "✅ Тест 3 пройден: Все $TESTS ИНН уникальны"
    else
        echo "⚠️ Тест 3: Найдено $DUPLICATES дубликатов из $TESTS запусков"
    fi

    # Тест 4: Проверка граничных значений
    echo -e "\nТест 4: Проверка граничных случаев"
    TEST_CASES=(
        "0000000000"
        "9999999999"
        "1234567890"
    )

    for TEST_CASE in "${TEST_CASES[@]}"; do
        {
            declare -A nums
            for ((I=1; I<=9; I++)); do
                nums["num_$I"]=${TEST_CASE:$((I-1)):1}
            done
            # Остальной код скрипта...
        } > temp_script.sh

        chmod +x temp_script.sh
        OUTPUT=$(./temp_script.sh)

        if validate_inn "$OUTPUT"; then
            echo "✅ Граничный случай '$TEST_CASE': Контрольная сумма верна"
        else
            echo "❌ Граничный случай '$TEST_CASE': Ошибка"
        fi
        rm temp_script.sh
    done
}

test_inn_generation