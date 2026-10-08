import UIKit

private enum AppStyle {
    static let ink = UIColor(red: 0.10, green: 0.12, blue: 0.20, alpha: 1)
    static let secondary = UIColor(red: 0.40, green: 0.43, blue: 0.52, alpha: 1)
    static let accent = UIColor(red: 0.31, green: 0.24, blue: 0.88, alpha: 1)
    static let background = UIColor(red: 0.97, green: 0.97, blue: 1.00, alpha: 1)
}

struct Submission {
    let name: String
    let email: String
    let message: String
}

final class WelcomeViewController: UIViewController {
    private let nameField = UITextField()
    private let emailField = UITextField()
    private let messageView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "InputFlow"
        view.backgroundColor = AppStyle.background
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        buildInterface()
    }

    private func buildInterface() {
        let scroll = UIScrollView()
        let stack = UIStackView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 18
        view.addSubview(scroll)
        scroll.addSubview(stack)

        let header = UILabel()
        header.text = "Tell us a little\nabout yourself."
        header.numberOfLines = 0
        header.font = .systemFont(ofSize: 32, weight: .bold)
        header.textColor = AppStyle.ink
        let subhead = UILabel()
        subhead.text = "Your details will be passed to a review screen before anything is submitted."
        subhead.numberOfLines = 0
        subhead.font = .systemFont(ofSize: 16)
        subhead.textColor = AppStyle.secondary
        stack.addArrangedSubview(header)
        stack.addArrangedSubview(subhead)
        stack.setCustomSpacing(28, after: subhead)

        configure(nameField, placeholder: "Full name", icon: "person")
        configure(emailField, placeholder: "Email address", icon: "envelope")
        messageView.font = .systemFont(ofSize: 16)
        messageView.textColor = AppStyle.ink
        messageView.backgroundColor = .white
        messageView.layer.cornerRadius = 14
        messageView.layer.borderWidth = 1
        messageView.layer.borderColor = UIColor.systemGray5.cgColor
        messageView.textContainerInset = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        messageView.heightAnchor.constraint(equalToConstant: 126).isActive = true
        messageView.accessibilityLabel = "Message"
        stack.addArrangedSubview(nameField)
        stack.addArrangedSubview(emailField)
        stack.addArrangedSubview(messageView)

        let button = UIButton(type: .system)
        button.setTitle("Continue to review  ›", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppStyle.accent
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        button.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        stack.addArrangedSubview(button)

        NSLayoutConstraint.activate([
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor), scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -24),
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 24),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -28),
            stack.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -48)
        ])
    }

    private func configure(_ field: UITextField, placeholder: String, icon: String) {
        field.placeholder = placeholder
        field.font = .systemFont(ofSize: 16)
        field.textColor = AppStyle.ink
        field.backgroundColor = .white
        field.layer.cornerRadius = 14
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemGray5.cgColor
        field.heightAnchor.constraint(equalToConstant: 54).isActive = true
        field.leftView = UIImageView(image: UIImage(systemName: icon))
        field.leftView?.tintColor = AppStyle.secondary
        field.leftViewMode = .always
        field.leftView?.frame = CGRect(x: 0, y: 0, width: 48, height: 54)
        field.leftView?.contentMode = .center
        field.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    @objc private func continueTapped() {
        let submission = Submission(name: nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                                    email: emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                                    message: messageView.text.trimmingCharacters(in: .whitespacesAndNewlines))
        guard !submission.name.isEmpty, !submission.email.isEmpty else {
            let alert = UIAlertController(title: "Almost there", message: "Please enter your name and email address.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        navigationController?.pushViewController(ReviewViewController(submission: submission), animated: true)
    }
}

final class ReviewViewController: UIViewController {
    private let submission: Submission
    init(submission: Submission) { self.submission = submission; super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Review"
        view.backgroundColor = AppStyle.background
        let stack = UIStackView()
        stack.axis = .vertical; stack.spacing = 16; stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        let titleLabel = UILabel(); titleLabel.text = "Check your details"; titleLabel.font = .systemFont(ofSize: 30, weight: .bold); titleLabel.textColor = AppStyle.ink
        let subtitle = UILabel(); subtitle.text = "Everything looks good? Submit when you’re ready."; subtitle.numberOfLines = 0; subtitle.textColor = AppStyle.secondary; subtitle.font = .systemFont(ofSize: 16)
        stack.addArrangedSubview(titleLabel); stack.addArrangedSubview(subtitle); stack.setCustomSpacing(20, after: subtitle)
        stack.addArrangedSubview(detail("NAME", submission.name)); stack.addArrangedSubview(detail("EMAIL", submission.email)); stack.addArrangedSubview(detail("MESSAGE", submission.message.isEmpty ? "No message added" : submission.message))
        let submit = UIButton(type: .system); submit.setTitle("Submit details", for: .normal); submit.setTitleColor(.white, for: .normal); submit.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold); submit.backgroundColor = AppStyle.accent; submit.layer.cornerRadius = 16; submit.heightAnchor.constraint(equalToConstant: 56).isActive = true; submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside); stack.addArrangedSubview(submit)
        NSLayoutConstraint.activate([stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24), stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24), stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28)])
    }
    private func detail(_ label: String, _ value: String) -> UIView { let box = UIStackView(); box.axis = .vertical; box.spacing = 6; box.isLayoutMarginsRelativeArrangement = true; box.layoutMargins = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16); box.backgroundColor = .white; box.layer.cornerRadius = 14; let l = UILabel(); l.text = label; l.font = .systemFont(ofSize: 11, weight: .bold); l.textColor = AppStyle.secondary; let v = UILabel(); v.text = value; v.numberOfLines = 0; v.font = .systemFont(ofSize: 17); v.textColor = AppStyle.ink; box.addArrangedSubview(l); box.addArrangedSubview(v); return box }
    @objc private func submitTapped() { navigationController?.pushViewController(SuccessViewController(), animated: true) }
}

final class SuccessViewController: UIViewController {
    override func viewDidLoad() { super.viewDidLoad(); title = "Complete"; view.backgroundColor = AppStyle.background; let stack = UIStackView(); stack.axis = .vertical; stack.alignment = .center; stack.spacing = 16; stack.translatesAutoresizingMaskIntoConstraints = false; view.addSubview(stack); let icon = UIImageView(image: UIImage(systemName: "checkmark.circle.fill")); icon.tintColor = .systemGreen; icon.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 72, weight: .regular); let title = UILabel(); title.text = "You’re all set!"; title.font = .systemFont(ofSize: 30, weight: .bold); title.textColor = AppStyle.ink; let body = UILabel(); body.text = "Your information was passed successfully."; body.textColor = AppStyle.secondary; body.textAlignment = .center; body.numberOfLines = 0; body.font = .systemFont(ofSize: 16); let done = UIButton(type: .system); done.setTitle("Start over", for: .normal); done.setTitleColor(.white, for: .normal); done.backgroundColor = AppStyle.accent; done.layer.cornerRadius = 16; done.heightAnchor.constraint(equalToConstant: 54).isActive = true; done.widthAnchor.constraint(equalToConstant: 220); done.addTarget(self, action: #selector(startOver), for: .touchUpInside); stack.addArrangedSubview(icon); stack.addArrangedSubview(title); stack.addArrangedSubview(body); stack.setCustomSpacing(18, after: body); stack.addArrangedSubview(done); NSLayoutConstraint.activate([stack.centerXAnchor.constraint(equalTo: view.centerXAnchor), stack.centerYAnchor.constraint(equalTo: view.centerYAnchor), stack.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 28), stack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -28)]) }
    @objc private func startOver() { navigationController?.popToRootViewController(animated: true) }
}
