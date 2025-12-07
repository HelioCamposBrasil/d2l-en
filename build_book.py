
import os

def process_chapter(chapter_dir, book_file):
    index_file = os.path.join(chapter_dir, 'index.md')
    print(f"Processing chapter: {chapter_dir}")

    if os.path.exists(index_file):
        with open(index_file, 'r') as f:
            content = f.read()
            book_file.write(content)
            book_file.write('\n\n')
            print(f"  Appended {index_file}")

        # Find and process the toc block
        in_toc = False
        for line in content.splitlines():
            if '```toc' in line:
                in_toc = True
                continue
            if '```' in line and in_toc:
                in_toc = False
                continue

            if in_toc and ':maxdepth:' not in line and line.strip():
                section = line.strip()
                section_file_md = os.path.join(chapter_dir, f'{section}.md')
                section_file_no_ext = os.path.join(chapter_dir, section)

                if os.path.exists(section_file_md):
                    with open(section_file_md, 'r') as sf:
                        book_file.write(sf.read())
                        book_file.write('\n\n')
                        print(f"      Appended {section_file_md}")
                elif os.path.exists(section_file_no_ext):
                    with open(section_file_no_ext, 'r') as sf:
                        book_file.write(sf.read())
                        book_file.write('\n\n')
                        print(f"      Appended {section_file_no_ext}")
                else:
                    print(f"      File not found: {section_file_md} or {section_file_no_ext}")

    else:
        print(f"  Index file not found: {index_file}")


def main():
    chapters = [
        "chapter_preface", "chapter_installation", "chapter_notation",
        "chapter_introduction", "chapter_preliminaries", "chapter_linear-regression",
        "chapter_linear-classification", "chapter_multilayer-perceptrons",
        "chapter_builders-guide", "chapter_convolutional-neural-networks",
        "chapter_convolutional-modern", "chapter_recurrent-neural-networks",
        "chapter_recurrent-modern", "chapter_attention-mechanisms-and-transformers",
        "chapter_optimization", "chapter_computational-performance", "chapter_computer-vision",
        "chapter_natural-language-processing-pretraining", "chapter_natural-language-processing-applications",
        "chapter_reinforcement-learning", "chapter_gaussian-processes",
        "chapter_hyperparameter-optimization", "chapter_generative-adversarial-networks",
        "chapter_recommender-systems", "chapter_appendix-mathematics-for-deep-learning",
        "chapter_appendix-tools-for-deep-learning", "chapter_references"
    ]

    with open('book.md', 'w') as book_file:
        with open('index.md', 'r') as f:
            book_file.write(f.read())
            book_file.write('\n\n')

        for chapter in chapters:
            process_chapter(chapter, book_file)

if __name__ == '__main__':
    main()
