document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('[data-tabs]').forEach(set => {
    const tabs=[...set.querySelectorAll('.ha-tab')];
    const panels=[...set.querySelectorAll('.ha-tab-panel')];
    tabs.forEach(tab => tab.addEventListener('click', () => {
      tabs.forEach(t=>t.classList.remove('active'));
      panels.forEach(p=>p.classList.remove('active'));
      tab.classList.add('active');
      const panel=set.querySelector(`[data-panel="${tab.dataset.tab}"]`);
      if(panel) panel.classList.add('active');
    }));
  });
  const filters=[...document.querySelectorAll('[data-filter]')];
  const cards=[...document.querySelectorAll('.status-card[data-status]')];
  filters.forEach(btn=>btn.addEventListener('click',()=>{
    filters.forEach(b=>b.classList.remove('active')); btn.classList.add('active');
    const f=btn.dataset.filter;
    cards.forEach(c=>c.classList.toggle('hidden', f!=='all' && c.dataset.status!==f));
  }));
});
