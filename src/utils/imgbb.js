const IMGBB_KEY = import.meta.env.VITE_IMGBB_API_KEY;

export async function uploadToImgBB(file) {
  if (!file) return '';
  const formData = new FormData();
  formData.append('image', file);
  const url = 'https://api.imgbb.com/1/upload?key=' + IMGBB_KEY;
  const res = await fetch(url, { method: 'POST', body: formData });
  const data = await res.json();
  if (!data.success) throw new Error('Upload failed');
  return data.data.url;
}
