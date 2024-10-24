using System.Text;

namespace backend
{
    public class FileWrapper
    {
        private string? _content;
        private bool _stored = true;

        public required string source { get; set; }
        public string path {
            get {
                return source;
            }
            set {
                File.Delete(value); // Ensure target file does not exists
                File.Copy(source, value);
                source = value;
            }
        }
        public string content {
            get {
                if (_content == null) {
                    _content = _stored ? File.ReadAllText(source) : "";
                }
                return _content;
            }
            set {
                _content = value;
                if (_stored) {
                    var payload = Encoding.UTF8.GetBytes(value);
                    var fs = File.OpenWrite(source);
                    fs.Write(payload);
                    fs.Close();
                }
            }
        }
        public bool stored {
            get {
                return _stored;
            }
            set {
                if (value == _stored) return;
                if (value) {
                    _stored = value;
                    content = content;
                }
                else {
                    File.Delete(source);
                    _stored = value;
                }
            }
        }
    }
}
