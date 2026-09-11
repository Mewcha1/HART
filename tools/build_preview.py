from pathlib import Path
import re, html, shutil
import mistune
ROOT=Path(__file__).resolve().parents[1]
BOOK=ROOT/'book'; OUT=ROOT/'preview'
if OUT.exists(): shutil.rmtree(OUT)
(OUT/'_static').mkdir(parents=True)
shutil.copytree(BOOK/'_static'/'img', OUT/'_static'/'img')
shutil.copy2(BOOK/'_static'/'custom.css', OUT/'_static'/'custom.css')
shutil.copy2(BOOK/'_static'/'custom.js', OUT/'_static'/'custom.js')
nav=[
('Home','intro.md'),('Project Overview','project_overview.md'),('Study Areas','study_area.md'),
('Research Program','research/index.md'),('Task 1 — Lysimeter','research/task1.md'),('Task 2 — Field','research/task2.md'),('Task 3 — Watershed/AI','research/task3.md'),
('Quality & Data','quality_data.md'),('Progress','progress.md'),('Team','team.md'),('Outputs','outputs.md'),('Events & Gallery','events_gallery.md')]
md=mistune.create_markdown(escape=False, plugins=['table','strikethrough','task_lists'])
shell_css="""body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Arial,sans-serif}.preview-shell{display:grid;grid-template-columns:270px 1fr;min-height:100vh}.side{background:#f6faf9;border-right:1px solid #d9e4e7;padding:1.2rem;position:sticky;top:0;height:100vh;overflow:auto}.brand{display:flex;align-items:center;gap:.7rem;margin-bottom:1rem}.brand img{width:46px}.brand b{color:#17394b}.side a{display:block;padding:.5rem .65rem;border-radius:8px;text-decoration:none;color:#314850;font-size:.9rem}.side a:hover{background:#e9f3f2}.main{max-width:1050px;padding:2rem 3rem 4rem;min-width:0}.preview-note{font-size:.75rem;background:#17394b;color:white;padding:.35rem .7rem;text-align:center}@media(max-width:850px){.preview-shell{display:block}.side{position:relative;height:auto}.main{padding:1.2rem}}"""
(OUT/'_static'/'preview_shell.css').write_text(shell_css,encoding='utf-8')

def outpath(src):
    p=Path(src); return p.with_suffix('.html')

def render(src_rel):
    src=BOOK/src_rel; text=src.read_text(encoding='utf-8')
    body=md(text)
    body=re.sub(r'href="([^"#]+)\.md([#"]?)', lambda m: f'href="{str(Path(m.group(1)).with_suffix(".html"))}{m.group(2)}', body)
    # prefix links/assets based on nesting depth
    depth=len(Path(src_rel).parts)-1
    prefix='../'*depth
    body=body.replace('src="_static/',f'src="{prefix}_static/').replace('href="research/',f'href="{prefix}research/') if depth==0 else body
    # For research pages, relative ../_static already works as written.
    links=''.join(f'<a href="{prefix}{outpath(p)}">{html.escape(label)}</a>' for label,p in nav)
    page=f"""<!doctype html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><link rel="stylesheet" href="{prefix}_static/preview_shell.css"><link rel="stylesheet" href="{prefix}_static/custom.css"><title>{html.escape(text.splitlines()[0].lstrip('# ').strip())}</title></head><body><div class="preview-note">Static preview of the Jupyter Book source — GitHub Pages uses the automated Jupyter Book build.</div><div class="preview-shell"><aside class="side"><div class="brand"><img src="{prefix}_static/img/project_logo.svg"><b>Humic Acid<br>Red Tide Mitigation</b></div>{links}</aside><main class="main">{body}</main></div><script src="{prefix}_static/custom.js"></script></body></html>"""
    dst=OUT/outpath(src_rel); dst.parent.mkdir(parents=True,exist_ok=True); dst.write_text(page,encoding='utf-8')
for _,src in nav: render(src)
(OUT/'index.html').write_text('<meta http-equiv="Refresh" content="0; url=intro.html" />',encoding='utf-8')
print('Preview built:',OUT)
