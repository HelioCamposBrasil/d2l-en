
#!/bin/bash

# Start fresh
rm -f book.md
touch book.md
cat index.md >> book.md
echo -e "\n\n" >> book.md
rm -f debug.log
touch debug.log

# The main function to process a chapter
process_chapter() {
    local chapter_dir=$1
    local index_file="${chapter_dir}/index.md"
    echo "Processing chapter: ${chapter_dir}" >> debug.log

    # Append the chapter's index.md content
    if [ -f "$index_file" ]; then
        cat "$index_file" >> book.md
        echo -e "\n\n" >> book.md
        echo "  Appended ${index_file}" >> debug.log

        # Use a more robust awk script to extract toc content
        toc_content=$(awk '/^```toc/,/^```/ {if (!/```toc/ && !/```/ && !/:maxdepth:/ && NF) print}' "$index_file")

        if [ -n "$toc_content" ]; then
            echo "$toc_content" | while read -r section; do
                # Trim whitespace
                section=$(echo "$section" | xargs)
                if [ -n "$section" ]; then
                    section_file="${chapter_dir}/${section}.md"
                    echo "    Processing section: ${section_file}" >> debug.log
                    if [ -f "$section_file" ]; then
                        cat "$section_file" >> book.md
                        echo -e "\n\n" >> book.md
                        echo "      Appended ${section_file}" >> debug.log
                    else
                        # Handle cases like chapter_references/zreferences
                        section_file_no_ext="${chapter_dir}/${section}"
                         if [ -f "$section_file_no_ext" ]; then
                            cat "$section_file_no_ext" >> book.md
                            echo -e "\n\n" >> book.md
                            echo "      Appended ${section_file_no_ext}" >> debug.log
                         else
                            echo "      File not found: ${section_file} or ${section_file_no_ext}" >> debug.log
                        fi
                    fi
                fi
            done
        fi
    else
        echo "  Index file not found: ${index_file}" >> debug.log
    fi
}

# The list of chapters from the main index.md
chapters=(
    "chapter_preface"
    "chapter_installation"
    "chapter_notation"
    "chapter_introduction"
    "chapter_preliminaries"
    "chapter_linear-regression"
    "chapter_linear-classification"
    "chapter_multilayer-perceptrons"
    "chapter_builders-guide"
    "chapter_convolutional-neural-networks"
    "chapter_convolutional-modern"
    "chapter_recurrent-neural-networks"
    "chapter_recurrent-modern"
    "chapter_attention-mechanisms-and-transformers"
    "chapter_optimization"
    "chapter_computational-performance"
    "chapter_computer-vision"
    "chapter_natural-language-processing-pretraining"
    "chapter_natural-language-processing-applications"
    "chapter_reinforcement-learning"
    "chapter_gaussian-processes"
    "chapter_hyperparameter-optimization"
    "chapter_generative-adversarial-networks"
    "chapter_recommender-systems"
    "chapter_appendix-mathematics-for-deep-learning"
    "chapter_appendix-tools-for-deep-learning"
    "chapter_references"
)

# Process each chapter
for chapter in "${chapters[@]}"; do
    process_chapter "$chapter"
done
